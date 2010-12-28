/* Yet Another Forum.NET
 * Copyright (C) 2006-2010 Jaben Cargman
 * http://www.yetanotherforum.net/
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
namespace YAF.Core
{
  #region Using

  using System;
  using System.Collections.Generic;
  using System.Diagnostics;
  using System.Linq;
  using System.Web;

  using YAF.Core;
  using YAF.Core.Tasks;
  using YAF.Types.Interfaces; using YAF.Types.Constants;
  using YAF.Classes.Pattern;
  using YAF.Utils;
  using YAF.Utils.Helpers.StringUtils;
  using YAF.Types;

  #endregion

  /// <summary>
  /// Runs Tasks in the background -- controlled by the context.
  /// </summary>
  public class YafTaskModule : IHttpModule
  {
    #region Constants and Fields

    /// <summary>
    ///   The _app instance.
    /// </summary>
    protected static HttpApplication _appInstance;

    /// <summary>
    ///   The _lock object.
    /// </summary>
    protected static object _lockObject = new object();

    /// <summary>
    ///   The _lock task manager object.
    /// </summary>
    protected static object _lockTaskManagerObject = new object();

    /// <summary>
    ///   The _module initialized.
    /// </summary>
    protected static bool _moduleInitialized;

    /// <summary>
    ///   The _task manager.
    /// </summary>
    protected static Dictionary<string, IBackgroundTask> _taskManager = new Dictionary<string, IBackgroundTask>();

    /// <summary>
    ///   The _module app name.
    /// </summary>
    private const string _moduleAppName = "YafTaskModule";

    #endregion

    #region Properties

    /// <summary>
    ///   Gets Current.
    /// </summary>
    [CanBeNull]
    public static YafTaskModule Current
    {
      get
      {
        if (YafContext.Application[_moduleAppName] != null)
        {
          return YafContext.Application[_moduleAppName] as YafTaskModule;
        }

        return null;
      }
    }

    /// <summary>
    ///   Gets TaskCount.
    /// </summary>
    public int TaskCount
    {
      get
      {
        return _taskManager.Count;
      }
    }

    /// <summary>
    ///   Current Page Instance of the Module Manager
    /// </summary>
    public Dictionary<string, IBackgroundTask> TaskManager
    {
      get
      {
        return _taskManager;
      }
    }

    /// <summary>
    ///   All the names of tasks running.
    /// </summary>
    [NotNull]
    public List<string> TaskManagerInstances
    {
      get
      {
        lock (_lockTaskManagerObject)
        {
          return this.TaskManager.Keys.ToList();
        }
      }
    }

    /// <summary>
    ///   Gets TaskManagerSnapshot.
    /// </summary>
    [NotNull]
    public Dictionary<string, IBackgroundTask> TaskManagerSnapshot
    {
      get
      {
        var tasks = new Dictionary<string, IBackgroundTask>();

        lock (_lockTaskManagerObject)
        {
          _taskManager.ToList().ForEach(x => tasks.Add(x.Key, x.Value));
        }

        return tasks;
      }
    }

    #endregion

    #region Public Methods

    /// <summary>
    /// Check if a Task is Running.
    /// </summary>
    /// <param name="instanceName">
    /// </param>
    /// <returns>
    /// The is task running.
    /// </returns>
    public bool IsTaskRunning([NotNull] string instanceName)
    {
      lock (_lockTaskManagerObject)
      {
        if (this.TaskManager.ContainsKey(instanceName) && this.TaskManager[instanceName].IsRunning)
        {
          return true;
        }
      }

      return false;
    }

    /// <summary>
    /// Start a non-running task -- will set the <see cref="HttpApplication"/> instance.
    /// </summary>
    /// <param name="instanceName">
    /// Unique name of this task
    /// </param>
    /// <param name="start">
    /// Task to run
    /// </param>
    public void StartTask([NotNull] string instanceName, [NotNull] IBackgroundTask start)
    {
      if (_moduleInitialized)
      {
        // add and start this module...
        if (!start.IsRunning && !this.TaskExists(instanceName))
        {
          Debug.WriteLine("Starting Task {0} Under User {1}...".FormatWith(instanceName, Environment.UserName));

          // setup and run...
          start.AppContext = _appInstance;
          start.Run();

          // add it after so that IsRunning is set first...
          this.AddTask(instanceName, start);
        }
      }
    }

    /// <summary>
    /// Stops a task from running if it's not critical
    /// </summary>
    /// <param name="instanceName">
    /// </param>
    public void StopTask([NotNull] string instanceName)
    {
      if (_moduleInitialized)
      {
        var task = this.TryGetTask(instanceName);

        if (task != null && task.IsRunning && !(task is ICriticalBackgroundTask))
        {
          if (this.TryRemoveTask(instanceName))
          {
            Debug.WriteLine("Stopped Task {0}...".FormatWith(instanceName));
            task.Dispose();
          }
        }
      }
    }

    /// <summary>
    /// Check if a task exists in the task manager. May not be running.
    /// </summary>
    /// <param name="instanceName">
    /// </param>
    /// <returns>
    /// The task exists.
    /// </returns>
    public bool TaskExists([NotNull] string instanceName)
    {
      lock (_lockTaskManagerObject)
      {
        return this.TaskManager.ContainsKey(instanceName);
      }
    }

    /// <summary>
    /// Attempt to get the instance of the task.
    /// </summary>
    /// <param name="instanceName">
    /// </param>
    /// <returns>
    /// </returns>
    public IBackgroundTask TryGetTask([NotNull] string instanceName)
    {
      lock (_lockTaskManagerObject)
      {
        if (this.TaskManager.ContainsKey(instanceName))
        {
          return this.TaskManager[instanceName];
        }
      }

      return null;
    }

    #endregion

    #region Implemented Interfaces

    #region IHttpModule

    /// <summary>
    /// Disposes of the resources (other than memory) used by the module that implements <see cref="T:System.Web.IHttpModule"/>.
    /// </summary>
    public void Dispose()
    {
    }

    /// <summary>
    /// The i http module. init.
    /// </summary>
    /// <param name="httpApplication">
    /// The http application.
    /// </param>
    public void Init([NotNull] HttpApplication httpApplication)
    {
      if (!_moduleInitialized)
      {
        // create a lock so no other instance can affect the static variable
        lock (_lockObject)
        {
          if (!_moduleInitialized)
          {
            _appInstance = httpApplication;

            // create a hook into the application allow YAF to find this handler...
            httpApplication.Application.Add(_moduleAppName, this);

            _moduleInitialized = true;

            // create intermittent cleanup task...
            this.StartTask("CleanUpTask", new CleanUpTask { Module = this });
          }
        }

        // now lock is released and the static variable is true..
      }
    }

    #endregion

    #endregion

    #region Methods

    /// <summary>
    /// The try remove task.
    /// </summary>
    /// <param name="instanceName">
    /// The instance name.
    /// </param>
    /// <returns>
    /// The try remove task.
    /// </returns>
    internal bool TryRemoveTask([NotNull] string instanceName)
    {
      lock (_lockTaskManagerObject)
      {
        if (this.TaskManager.ContainsKey(instanceName))
        {
          this.TaskManager.Remove(instanceName);
          return true;
        }
      }

      return false;
    }

    /// <summary>
    /// The add task.
    /// </summary>
    /// <param name="instanceName">
    /// The instance name.
    /// </param>
    /// <param name="newTask">
    /// The new task.
    /// </param>
    protected void AddTask([NotNull] string instanceName, [NotNull] IBackgroundTask newTask)
    {
      lock (_lockTaskManagerObject)
      {
        if (!this.TaskManager.ContainsKey(instanceName))
        {
          this.TaskManager.Add(instanceName, newTask);
        }
        else
        {
          this.TaskManager[instanceName] = newTask;
        }
      }
    }

    #endregion
  }
}
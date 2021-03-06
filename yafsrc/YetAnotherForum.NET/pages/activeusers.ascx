<%@ Control Language="c#" AutoEventWireup="True" Inherits="YAF.Pages.activeusers" Codebehind="activeusers.ascx.cs" %>
<%@ Import Namespace="YAF.Types.Interfaces" %>
<%@ Import Namespace="YAF.Utils.Helpers" %>
<YAF:PageLinks runat="server" ID="PageLinks" />

<asp:Repeater ID="UserList" runat="server">
	<HeaderTemplate>
        <div class="row">
            <div class="col-xl-12">
                <div class="card mb-3">
                    <div class="card-header">
                        <i class="fa fa-users fa-fw"></i> <YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="title" />
                    </div>
                    <div class="card-body">
                        <YAF:Alert runat="server" ID="MobileInfo" Type="info" MobileOnly="True">
                            <YAF:LocalizedLabel ID="LocalizedLabel220" runat="server" LocalizedTag="TABLE_RESPONSIVE" LocalizedPage="ADMIN_COMMON" />
                            <span class="float-right"><i class="fa fa-hand-point-left fa-fw"></i></span>
                        </YAF:Alert>
                        <div class="table-responsive">
	                        <table style="width:100%"  cellspacing="1" cellpadding="0" class="tablesorter" id="ActiveUsers">
                                <thead>
                                    <tr>
                                        <th>
                                            <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" 
                                                                LocalizedTag="username" />
                                        </th>
                                        <th>
                                            <YAF:LocalizedLabel ID="LocalizedLabelLatestActions" runat="server" 
                                                                LocalizedTag="latest_action" />
                                        </th>
                                        <th>
                                            <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" 
                                                                LocalizedTag="logged_in" />
                                        </th>
                                        <th>
                                            <YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" 
                                                                LocalizedTag="last_active" />
                                        </th>
                                        <th>
                                            <YAF:LocalizedLabel ID="LocalizedLabel5" runat="server" 
                                                                LocalizedTag="active" />
                                        </th>
                                        <th>
                                            <YAF:LocalizedLabel ID="LocalizedLabel6" runat="server" 
                                                                LocalizedTag="browser" />
		                                </th>
                                        <th>
                                            <YAF:LocalizedLabel ID="LocalizedLabel7" runat="server" 
                                                                LocalizedTag="platform" />
		                                </th>
                                        <th id="Iptd_header1" runat="server" 
                                            visible='<%# this.PageContext.IsAdmin %>'>
                                            IP
		                                </th>
                                    </tr>
                                </thead>
                            <tbody>
	                    </HeaderTemplate>
		                <ItemTemplate>
                        <tr>
				        <td class="post">		
					        <YAF:UserLink ID="NameLink"  runat="server" ReplaceName='<%# this.Get<YafBoardSettings>().EnableDisplayName
                              ? this.Eval("UserDisplayName")
                              : this.Eval("UserName") %>' CrawlerName='<%# Convert.ToInt32(this.Eval("IsCrawler")) > 0 ? this.Eval("Browser").ToString() : String.Empty %>' 
                                UserID='<%# Convert.ToInt32(this.Eval("UserID")) %>' 				
                                Style='<%# this.Eval("Style").ToString() %>' />
                            <asp:PlaceHolder ID="HiddenPlaceHolder" runat="server" Visible='<%# Convert.ToBoolean(this.Eval("IsHidden"))%>' >
                                (<YAF:LocalizedLabel ID="Hidden" LocalizedTag="HIDDEN" runat="server" />)
                            </asp:PlaceHolder>				    
				        </td>
				        <td class="post">				
					        <YAF:ActiveLocation ID="ActiveLocation2" UserID='<%# Convert.ToInt32((this.Eval("UserID") == DBNull.Value)? 0 : this.Eval("UserID")) %>' 
                                UserName='<%# this.Eval("UserName") %>' HasForumAccess='<%# Convert.ToBoolean(this.Eval("HasForumAccess")) %>' ForumPage='<%# this.Eval("ForumPage") %>' 
                                ForumID='<%# Convert.ToInt32((this.Eval("ForumID") == DBNull.Value)? 0 : this.Eval("ForumID")) %>' ForumName='<%# this.Eval("ForumName") %>' 
                                TopicID='<%# Convert.ToInt32((this.Eval("TopicID") == DBNull.Value)? 0 : this.Eval("TopicID")) %>' TopicName='<%# this.Eval("TopicName") %>' 
                                LastLinkOnly="false"  runat="server"></YAF:ActiveLocation>     
				        </td>
				        <td class="post">
					        <%# this.Get<IDateTime>().FormatTime((DateTime)((System.Data.DataRowView)Container.DataItem)["Login"]) %>
				        </td>				
				        <td class="post">
					        <%# this.Get<IDateTime>().FormatTime((DateTime)((System.Data.DataRowView)Container.DataItem)["LastActive"]) %>
				        </td>
				        <td class="post">
					        <%# this.Get<ILocalization>().GetTextFormatted("minutes", ((System.Data.DataRowView)Container.DataItem)["Active"])%>
				        </td>
				        <td class="post">
					        <%# this.Eval("Browser") %>
				        </td>
				        <td class="post">
					        <%# this.Eval("Platform") %>
				        </td>
                        <td id="Iptd1" class="post" runat="server" visible='<%# this.PageContext.IsAdmin %>'>
					         <a id="Iplink1" href='<%# string.Format(this.PageContext.BoardSettings.IPInfoPageURL,IPHelper.GetIp4Address(this.Eval("IP").ToString())) %>'
                                title='<%# this.GetText("COMMON","TT_IPDETAILS") %>' target="_blank" runat="server">
                             <%# IPHelper.GetIp4Address(this.Eval("IP").ToString())%></a>
				        </td>
                    </tr>	
                        </ItemTemplate>
                        <FooterTemplate>
                            </table>
                        </div>
                        </div>
            <div class="card-footer">
            <div id="ActiveUsersPager" class=" tableSorterPager form-inline">
                <select class="pagesize custom-select">
                    <option selected="selected"  value="10">10</option>
                    <option value="20">20</option>
                    <option value="30">30</option>
                    <option  value="40">40</option>
                </select>
                &nbsp;
                <div class="btn-group"  role="group">
                    <a href="#" class="first  btn btn-secondary btn-sm"><span>&lt;&lt;</span></a>
                    <a href="#" class="prev  btn btn-secondary btn-sm"><span>&lt;</span></a>
                    <input type="text" class="pagedisplay  btn btn-secondary btn-sm"  style="width:150px" />
                    <a href="#" class="next btn btn-secondary btn-sm"><span>&gt;</span></a>
                    <a href="#" class="last  btn btn-secondary btn-sm"><span>&gt;&gt;</span></a>
                </div>
            </div>
                </div>
            </div>
        </div>
    </FooterTemplate>
</asp:Repeater>

<div id="DivSmartScroller">
	
</div>

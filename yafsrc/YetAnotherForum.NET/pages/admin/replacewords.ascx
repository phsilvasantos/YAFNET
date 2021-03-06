<%@ Control Language="c#" Debug="true" AutoEventWireup="True"
	Inherits="YAF.Pages.Admin.replacewords" Codebehind="replacewords.ascx.cs" %>

<%@ Register TagPrefix="modal" TagName="Import" Src="../../Dialogs/ReplaceWordsImport.ascx" %>
<%@ Register TagPrefix="modal" TagName="Edit" Src="../../Dialogs/ReplaceWordsEdit.ascx" %>

<YAF:PageLinks runat="server" ID="PageLinks" />

	<asp:Repeater ID="list" runat="server">
		<HeaderTemplate>
    <div class="row">
    <div class="col-xl-12">
        <h1><YAF:LocalizedLabel ID="LocalizedLabel1" runat="server" LocalizedTag="TITLE" LocalizedPage="ADMIN_REPLACEWORDS" /></h1>
    </div>
    </div>
    <div class="row">
        <div class="col-xl-12">
            <div class="card mb-3">
                <div class="card-header">
                    <i class="fa fa-sticky-note fa-fw"></i>&nbsp;<YAF:LocalizedLabel ID="LocalizedLabel4" runat="server" LocalizedTag="TITLE" LocalizedPage="ADMIN_REPLACEWORDS" />
                </div>
                <div class="card-body">
                    <ul class="list-group">
		</HeaderTemplate>
		<ItemTemplate>
            <li class="list-group-item list-group-item-action">
                <div class="d-flex w-100 justify-content-between">
                    <h5 class="mb-1">
                        <YAF:LocalizedLabel ID="LocalizedLabel2" runat="server" LocalizedTag="BAD" LocalizedPage="ADMIN_REPLACEWORDS" />
                        
                    </h5>
                    <small><YAF:ThemeButton ID="btnEdit" Type="Info" Size="Small" CommandName='edit' CommandArgument='<%# this.Eval("ID") %>'
                                            TextLocalizedTag="EDIT"
                                            TitleLocalizedTag="EDIT" Icon="edit" runat="server">
                        </YAF:ThemeButton>
                        <YAF:ThemeButton ID="ThemeButtonDelete" Type="Danger" Size="Small" 
                                         CommandName='delete'
                                         TextLocalizedTag="DELETE"
                                         CommandArgument='<%# this.Eval( "ID") %>' TitleLocalizedTag="DELETE" Icon="trash" runat="server"
                                         ReturnConfirmText='<%# this.GetText("ADMIN_REPLACEWORDS", "MSG_DELETE") %>'>
                        </YAF:ThemeButton></small>
                </div>
                <p class="mb-1">
                    <%# this.HtmlEncode(this.Eval("badword")) %>
                </p>
                <small>
                    <YAF:LocalizedLabel ID="LocalizedLabel3" runat="server" LocalizedTag="GOOD" LocalizedPage="ADMIN_REPLACEWORDS" />: &nbsp;
                    <%# this.HtmlEncode(this.Eval("goodword")) %>
                </small>
			</li>
		</ItemTemplate>
		<FooterTemplate>
                    </ul>
                </div>
                <div class="card-footer text-center">
					<YAF:ThemeButton runat="server" CommandName='add' ID="Linkbutton3" Type="Primary"
					                 Icon="plus-square" TextLocalizedTag="ADD" TextLocalizedPage="ADMIN_REPLACEWORDS"> </YAF:ThemeButton>
					&nbsp;
					<YAF:ThemeButton runat="server" Icon="upload" DataTarget="ReplaceWordsImportDialog" ID="Linkbutton5" Type="Info"
					                 TextLocalizedTag="IMPORT" TextLocalizedPage="ADMIN_REPACEWORDS"></YAF:ThemeButton>
					&nbsp;
					<YAF:ThemeButton runat="server" CommandName='export' ID="Linkbutton4" Type="Warning"
					                 Icon="download" TextLocalizedTag="EXPORT" TextLocalizedPage="ADMIN_REPLACEWORDS"></YAF:ThemeButton>
                </div>
            </div>
        </div>
    </div>
		</FooterTemplate>
	</asp:Repeater>



<modal:Import ID="ImportDialog" runat="server" />
<modal:Edit ID="EditDialog" runat="server" />
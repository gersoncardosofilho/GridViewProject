<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="GridViewProject._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

   <h2>Currencies Table</h2>
    <script type="text/javascript">
        $(document).ready(function () {

            window.setTimeout(function () {
                $(".alert").fadeTo(1500, 0).slideUp(500, function () {
                    $(this).remove();
                });
            }, 2000);

        });
        function pageLoad() {
            $('.bs-pagination td table').each(function (index, obj) {
                convertToPagination(obj)
            });
        }
    </script>
    <br />
    <p>
        Use the Grid View below to enter your currencies. The <b>Exchange Rate</b> column is the value of the 
        Kenya Shilling to the entered currency.        
    </p>
    <br />
    <div>
        <asp:UpdatePanel ID="UpdatePanelCR" runat="server">
            <ContentTemplate>
                <asp:GridView ID="cRGridView"
                    runat="server"
                    AutoGenerateColumns="False"
                    AllowPaging="True"
                    AllowSorting="True"
                    ShowFooter="True"
                    OnRowEditing="cRGridView_RowEditing"
                    OnRowUpdating="cRGridView_RowUpdating"
                    OnPageIndexChanging="cRGridView_PageIndexChanging"
                    OnRowCancelingEdit="cRGridView_RowCancelingEdit"
                    PagerStyle-CssClass="bs-pagination"
                    ShowHeaderWhenEmpty="True"
                    EmptyDataText="No Records Found"
                    CssClass="table table-striped table-bordered table-hover table-condensed" 
                    Width="600px">
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="30px" HeaderText="CurrencyId" Visible="False">
                            <ItemTemplate>
                                <asp:Label ID="lblCurrencyId" runat="server"
                                    Text='<%# Bind("CurrencyId")%>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtCurrencyId" Width="40px"
                                    MaxLength="5" runat="server"></asp:TextBox>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="100px" HeaderText="Currency Name">
                            <ItemTemplate>
                                <asp:Label ID="lblCurrencyName" runat="server"
                                    Text='<%# Bind("CurrencyName")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtCurrencyName" runat="server"
                                    Text='<%# Bind("CurrencyName")%>'></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCurrencyName" Display="Dynamic" ValidationGroup="Edit"
                                    CssClass="text-danger" ErrorMessage="The Currency Name field is required." />
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtCurrencyName" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCurrencyName" Display="Dynamic" ValidationGroup="Insert"
                                    CssClass="text-danger" ErrorMessage="The Currency Name field is required." />
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="100px" HeaderText="Currency Symbol">
                            <ItemTemplate>
                                <asp:Label ID="lblCurrencySymbol" runat="server"
                                    Text='<%# Bind("CurrencySymbol")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtCurrencySymbol" runat="server"
                                    Text='<%# Bind("CurrencySymbol")%>'></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCurrencySymbol" Display="Dynamic" ValidationGroup="Edit"
                                    CssClass="text-danger" ErrorMessage="The Currency Symbol field is required." />
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtCurrencySymbol" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtCurrencySymbol" Display="Dynamic" ValidationGroup="Insert"
                                    CssClass="text-danger" ErrorMessage="The Currency Symbol field is required." />
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-Width="100px" HeaderText="Exchange Rate">
                            <ItemTemplate>
                                <asp:Label ID="lblExchangeRate" runat="server"
                                    Text='<%# Bind("ExchangeRate")%>'></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtExchangeRate" runat="server"
                                    Text='<%# Bind("ExchangeRate")%>'></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtExchangeRate" Display="Dynamic"
                                    CssClass="text-danger" ErrorMessage="The Exchange Rate field is required." ValidationGroup="Edit" />
                                <asp:RegularExpressionValidator ControlToValidate="txtExchangeRate" runat="server" CssClass="text-danger" Display="Dynamic"
                                    ErrorMessage="Only numbers allowed." ValidationExpression="^[0-9]{0,6}(\.[0-9]{1,2})?$"
                                    ValidationGroup="Edit"></asp:RegularExpressionValidator>
                            </EditItemTemplate>
                            <FooterTemplate>
                                <asp:TextBox ID="txtExchangeRate" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtExchangeRate" Display="Dynamic"
                                    CssClass="text-danger" ErrorMessage="The Exchange Rate field is required." ValidationGroup="Insert" />
                                <asp:RegularExpressionValidator ControlToValidate="txtExchangeRate" runat="server" CssClass="text-danger" Display="Dynamic"
                                    ErrorMessage="Only numbers allowed." ValidationExpression="^[0-9]{0,6}(\.[0-9]{1,2})?$"
                                    ValidationGroup="Insert"></asp:RegularExpressionValidator>
                            </FooterTemplate>
                        </asp:TemplateField>
                        <asp:CommandField ItemStyle-Width="100px" ShowEditButton="True" ValidationGroup="Edit" />
                        <asp:TemplateField ItemStyle-Width="50px">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkRemove" runat="server"
                                    CommandArgument='<%# Bind("CurrencyId")%>'
                                    OnClientClick="return confirm('Are you sure you want to delete this row?')"
                                    Text="Delete" OnClick="DeleteCurrency"></asp:LinkButton>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Button ID="btnAdd" runat="server" Text="Add" ValidationGroup="Insert" CssClass="btn btn-primary btn-sm"
                                    OnClick="AddNewCurrency" />
                            </FooterTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="cRGridView" />
            </Triggers>
        </asp:UpdatePanel>
    </div>

</asp:Content>

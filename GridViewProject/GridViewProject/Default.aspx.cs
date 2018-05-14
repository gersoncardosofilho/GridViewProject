using GridViewProject.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GridViewProject
{
    public partial class _Default : Page
    {
        protected GridViewProject.Models.ApplicationContext _db = new GridViewProject.Models.ApplicationContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                bindCRGridView();
            }
        }

        // Binding the GridView
        private void bindCRGridView()
        {
            // Get existing currencies
            var existingCR = _db.Currencies.ToList();

            // Create Data Table
            DataTable dt = new DataTable();
            dt.Columns.Add("CurrencyId", typeof(int));
            dt.Columns.Add("CurrencyName", typeof(string));
            dt.Columns.Add("CurrencySymbol", typeof(string));
            dt.Columns.Add("ExchangeRate", typeof(decimal));

            if (existingCR.Count > 0)
            {
                foreach (var item in existingCR)
                {
                    dt.Rows.Add(item.CurrencyId, item.CurrencyName, item.CurrencySymbol, item.ExchangeRate);
                }

                cRGridView.DataSource = dt;
                cRGridView.DataBind();

                if (cRGridView.Rows.Count > 0)
                {
                    cRGridView.UseAccessibleHeader = true;
                    cRGridView.HeaderRow.TableSection = TableRowSection.TableHeader;
                }

                cRGridView.Columns[4].Visible = true;
            }
            else
            {
                dt.Rows.Add(dt.NewRow());
                cRGridView.DataSource = dt;
                cRGridView.DataBind();

                cRGridView.Columns[4].Visible = false;
                foreach (GridViewRow row in cRGridView.Rows)
                {
                    if (row.RowType == DataControlRowType.DataRow)
                    {
                        LinkButton lb = ((LinkButton)row.FindControl("lnkRemove"));
                        lb.Visible = false;
                    }
                }
            }
        }

        // Adding new currency
        protected void AddNewCurrency(object sender, EventArgs e)
        {
            string currencyName = ((TextBox)cRGridView.FooterRow.FindControl("txtCurrencyName")).Text;
            string currencySymbol = ((TextBox)cRGridView.FooterRow.FindControl("txtCurrencySymbol")).Text;
            string exchangeRate = ((TextBox)cRGridView.FooterRow.FindControl("txtExchangeRate")).Text;

            Currency cTable = new Currency
            {          
                CurrencyName = currencyName,
                CurrencySymbol = currencySymbol,
                ExchangeRate = Decimal.Parse(exchangeRate),
                Created = DateTime.Now
            };

            if (ModelState.IsValid)
            {
                // Save record
                _db.Currencies.Add(cTable);
                _db.SaveChanges();
            }

            // Rebind Grid view
            bindCRGridView();
        }

        // Updating a currency
        protected void cRGridView_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            string currencyId = ((Label)cRGridView.Rows[e.RowIndex].FindControl("lblCurrencyId")).Text;
            string currencyName = ((TextBox)cRGridView.Rows[e.RowIndex].FindControl("txtCurrencyName")).Text;
            string currencySymbol = ((TextBox)cRGridView.Rows[e.RowIndex].FindControl("txtCurrencySymbol")).Text;
            string exchangeRate = ((TextBox)cRGridView.Rows[e.RowIndex].FindControl("txtExchangeRate")).Text;

            using (_db)
            {
                var item = _db.Currencies.Find(Convert.ToInt32(currencyId));

                if (item == null)
                {
                    // The item wasn't found
                    ModelState.AddModelError("", String.Format("Item with id {0} was not found", currencyId));
                    return;
                }

                item.CurrencyName = currencyName;
                item.CurrencySymbol = currencySymbol;
                item.ExchangeRate = Decimal.Parse(exchangeRate);
                item.Modified = DateTime.Now;

                if (ModelState.IsValid)
                {
                    // Save changes here
                    _db.SaveChanges();
                }

                cRGridView.EditIndex = -1;
                // Rebind Grid view
                bindCRGridView();
            }
        }

        // Deleting currency
        protected void DeleteCurrency(object sender, EventArgs e)
        {
            LinkButton lnkRemove = (LinkButton)sender;

            using (_db)
            {
                var item = _db.Currencies.Find(Convert.ToInt32(lnkRemove.CommandArgument));

                if (item != null)
                {
                    _db.Currencies.Remove(item);
                    _db.SaveChanges();
                }

                // Rebind Grid view
                bindCRGridView();
            }
        }

        // This event is raised when one of the paging buttons is clicked
        protected void cRGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            cRGridView.PageIndex = e.NewPageIndex;
            bindCRGridView();
        }

        // This event is raised when a row's Edit button is clicked, 
        // but before the GridView control enters edit mode
        protected void cRGridView_RowEditing(object sender, GridViewEditEventArgs e)
        {
            cRGridView.EditIndex = e.NewEditIndex;
            bindCRGridView();
        }

        // This event is raised when the Cancel button of a row in edit mode is clicked, 
        //but before the row exits edit mode
        protected void cRGridView_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            cRGridView.EditIndex = -1;
            bindCRGridView();
        }
    }
}
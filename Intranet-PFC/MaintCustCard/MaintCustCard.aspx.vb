
Partial Class _MaintCustCard
    Inherits System.Web.UI.Page
    Dim csNV, csList As New System.Data.SqlClient.SqlConnection("Data Source=EnterpriseSQL;Initial Catalog=PFCLive;Persist Security Info=True;User ID=pfcnormal;Password=pfcnormal")
    Dim csERP As New System.Data.SqlClient.SqlConnection("Data Source=PFCSQLP;Initial Catalog=PFCReports;Persist Security Info=True;User ID=pfcnormal;Password=pfcnormal")
    Dim cmdNV, cmdERP, updNV, updERP As New System.Data.SqlClient.SqlCommand
    Dim rsNV, rsERP As System.Data.SqlClient.SqlDataReader
    Dim adp As New Data.SqlClient.SqlDataAdapter
    Dim ds As New Data.DataSet
    Dim dr As Data.DataRow
    Dim Count As Integer
    Dim updUseLoc, updShipLoc, updShipAgent, updEShip, updShipMeth, updPriceGroup, updDiscGroup, updInsideSales, updChain As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        txtCustNo.Focus()
    End Sub

    Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnNext.Click
        rsRead()
    End Sub

    Public Sub rsRead()
        If txtCustNo.Text = "" Then
            txtCustNo.Text = lblCustNo.Text
        End If

        '---SELECT [Porteous$Customer] record for the specifiec Customer Number
        cmdNV.CommandText = "SELECT [No_], [Name], [Customer Price Code], [Customer Price Group], [Customer Disc_ Group], [Usage Location], [Shipping Location], [Shipping Payment Type], [Shipping Agent Code], [E-Ship Agent Service], [Shipment Method Code], [Backorder], [Free Freight], [Inside Salesperson], [Chain Name] FROM [Porteous$Customer] WHERE ([No_] = '" & txtCustNo.Text & "')"
        cmdNV.Connection = csNV
        csNV.Open()
        rsNV = cmdNV.ExecuteReader

        '---If the Customer Record is found, display current data and populate DropDown selections
        If rsNV.HasRows Then
            While rsNV.Read()
                lblCustNo.Text = rsNV("No_").ToString()
                lblCustDesc.Text = rsNV("Name").ToString()

                '---Usage Location
                adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, [Name 2], Code + ' - ' + [Name 2] as ListIndex FROM [Porteous$Location] ORDER BY Code", csList)
                adp.Fill(ds)
                csList.Close()
                ddUseLoc.DataSource = ds.Tables(0)
                ddUseLoc.DataTextField = "ListIndex"
                ddUseLoc.DataValueField = "Code"
                ddUseLoc.DataBind()
                ddUseLoc.Items.Insert(0, "---select value---")
                If rsNV("Usage Location").ToString() = "" Then
                    ddUseLoc.SelectedIndex = 0
                Else
                    For Count = 0 To ddUseLoc.Items.Count - 1
                        If ddUseLoc.Items(Count).Value.ToString() = (rsNV("Usage Location").ToString()) Then
                            ddUseLoc.SelectedIndex = Count
                        End If
                    Next Count
                End If

                '---Shipping Location
                ddShipLoc.DataSource = ds.Tables(0)
                ddShipLoc.DataTextField = "ListIndex"
                ddShipLoc.DataValueField = "Code"
                ddShipLoc.DataBind()
                ddShipLoc.Items.Insert(0, "---select value---")
                If rsNV("Shipping Location").ToString() = "" Then
                    ddShipLoc.SelectedIndex = 0
                Else
                    For Count = 0 To ddShipLoc.Items.Count - 1
                        If ddShipLoc.Items(Count).Value.ToString() = (rsNV("Shipping Location").ToString()) Then
                            ddShipLoc.SelectedIndex = Count
                        End If
                    Next Count
                End If

                '---Shipping Payment Type
                ddShipPayType.SelectedIndex = rsNV("Shipping Payment Type")
                'For Count = 0 To ddShipPayType.Items.Count - 1
                '    If ddShipPayType.Items(Count).Value.ToString() = (rsNV("Shipping Payment Type").ToString()) Then
                '        ddShipPayType.SelectedIndex = Count
                '    End If
                'Next Count

                '---Free Freight
                ddFreeFrt.SelectedIndex = rsNV("Free Freight")

                '---Backorder
                ddBackorder.SelectedIndex = rsNV("Backorder")

                '---Shipping Agent Code
                ds.Tables(0).Clear()
                adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, Name, Code + ' - ' + Name as ListIndex FROM [Porteous$Shipping Agent] ORDER BY Code", csList)
                adp.Fill(ds)
                csList.Close()
                ddShipAgent.DataSource = ds.Tables(0)
                ddShipAgent.DataTextField = "ListIndex"
                ddShipAgent.DataValueField = "Code"
                ddShipAgent.DataBind()
                ddShipAgent.Items.Insert(0, "---select value---")
                If rsNV("Shipping Agent Code").ToString() = "" Then
                    ddShipAgent.SelectedIndex = 0
                Else
                    For Count = 0 To ddShipAgent.Items.Count - 1
                        If ddShipAgent.Items(Count).Value.ToString() = (rsNV("Shipping Agent Code").ToString()) Then
                            ddShipAgent.SelectedIndex = Count
                        End If
                    Next Count
                End If
                'Response.Write(ddShipAgent.SelectedValue)

                '---E-Shipping Agent Service
                ds.Tables(0).Clear()
                If ddShipAgent.SelectedValue <> "" Then
                    adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, [Shipping Agent Code], Description, (Case WHEN (UPPER(Description) <> UPPER(Code)) THEN [Shipping Agent Code] + ' - ' + UPPER(Description) + ' (' + UPPER(Code) + ')' ELSE [Shipping Agent Code] + ' - ' + UPPER(Description) END) as ListIndex FROM [Porteous$E-Ship Agent Service] WHERE [World Wide Service]='0' AND [Shipping Agent Code] = '" & ddShipAgent.SelectedValue & "' ORDER BY Code", csList)
                Else
                    adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, [Shipping Agent Code], Description, (Case WHEN (UPPER(Description) <> UPPER(Code)) THEN [Shipping Agent Code] + ' - ' + UPPER(Description) + ' (' + UPPER(Code) + ')' ELSE [Shipping Agent Code] + ' - ' + UPPER(Description) END) as ListIndex FROM [Porteous$E-Ship Agent Service] WHERE [World Wide Service]='0' ORDER BY Code", csList)
                End If
                adp.Fill(ds)
                csList.Close()
                ddEShipAgent.DataSource = ds.Tables(0)
                ddEShipAgent.DataTextField = "ListIndex"
                ddEShipAgent.DataValueField = "Code"
                ddEShipAgent.DataBind()
                ddEShipAgent.Items.Insert(0, "---select value---")
                If rsNV("E-Ship Agent Service").ToString() = "" Then
                    ddEShipAgent.SelectedIndex = 0
                Else
                    For Count = 0 To ddEShipAgent.Items.Count - 1
                        If ddEShipAgent.Items(Count).Value.ToString() = (rsNV("E-Ship Agent Service").ToString()) Then
                            ddEShipAgent.SelectedIndex = Count
                        End If
                    Next Count
                End If

                '---Shipment Method Code
                ds.Tables(0).Clear()
                adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, Description, Code + ' - ' + Description as ListIndex FROM [Porteous$Shipment Method] ORDER BY Code", csList)
                adp.Fill(ds)
                csList.Close()
                ddShipMeth.DataSource = ds.Tables(0)
                ddShipMeth.DataTextField = "ListIndex"
                ddShipMeth.DataValueField = "Code"
                ddShipMeth.DataBind()
                ddShipMeth.Items.Insert(0, "---select value---")
                If rsNV("Shipment Method Code").ToString() = "" Then
                    ddShipMeth.SelectedIndex = 0
                Else
                    For Count = 0 To ddShipMeth.Items.Count - 1
                        If ddShipMeth.Items(Count).Value.ToString() = (rsNV("Shipment Method Code").ToString()) Then
                            ddShipMeth.SelectedIndex = Count
                        End If
                    Next Count
                End If

                '---Customer Price Code
                txtPriceCode.Text = rsNV("Customer Price Code").ToString()

                '---Customer Price Group
                ds.Tables(0).Clear()
                adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, Description, Code + ' - ' + Description as ListIndex FROM [Porteous$Customer Price Group] ORDER BY Code", csList)
                adp.Fill(ds)
                csList.Close()
                ddPriceGroup.DataSource = ds.Tables(0)
                ddPriceGroup.DataTextField = "ListIndex"
                ddPriceGroup.DataValueField = "Code"
                ddPriceGroup.DataBind()
                ddPriceGroup.Items.Insert(0, "---select value---")
                If rsNV("Customer Price Group").ToString() = "" Then
                    ddPriceGroup.SelectedIndex = 0
                Else
                    For Count = 0 To ddPriceGroup.Items.Count - 1
                        If ddPriceGroup.Items(Count).Value.ToString() = (rsNV("Customer Price Group").ToString()) Then
                            ddPriceGroup.SelectedIndex = Count
                        End If
                    Next Count
                End If

                '---Customer Disc_ Group
                ds.Tables(0).Clear()
                adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, Description, Code + ' - ' + Description as ListIndex FROM [Porteous$Customer Discount Group] ORDER BY Code", csList)
                adp.Fill(ds)
                csList.Close()
                ddDiscGroup.DataSource = ds.Tables(0)
                ddDiscGroup.DataTextField = "ListIndex"
                ddDiscGroup.DataValueField = "Code"
                ddDiscGroup.DataBind()
                ddDiscGroup.Items.Insert(0, "---select value---")
                If rsNV("Customer Disc_ Group").ToString() = "" Then
                    ddDiscGroup.SelectedIndex = 0
                Else
                    For Count = 0 To ddDiscGroup.Items.Count - 1
                        If ddDiscGroup.Items(Count).Value.ToString() = (rsNV("Customer Disc_ Group").ToString()) Then
                            ddDiscGroup.SelectedIndex = Count
                        End If
                    Next Count
                End If

                '---Inside Salesperson
                ds.Tables(0).Clear()
                adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, Name, Code + ' - ' + Name as ListIndex FROM [Porteous$Salesperson_Purchaser] ORDER BY Code", csList)
                adp.Fill(ds)
                csList.Close()
                ddInsideSales.DataSource = ds.Tables(0)
                ddInsideSales.DataTextField = "ListIndex"
                ddInsideSales.DataValueField = "Code"
                ddInsideSales.DataBind()
                ddInsideSales.Items.Insert(0, "---select value---")
                If rsNV("Inside Salesperson").ToString() = "" Then
                    ddInsideSales.SelectedIndex = 0
                Else
                    For Count = 0 To ddInsideSales.Items.Count - 1
                        If ddInsideSales.Items(Count).Value.ToString() = (rsNV("Inside Salesperson").ToString()) Then
                            ddInsideSales.SelectedIndex = Count
                        End If
                    Next Count
                End If

                '---Chain Name
                ds.Tables(0).Clear()
                adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, Name, Code + ' - ' + Name as ListIndex FROM [Porteous$Chain Name] ORDER BY Code", csList)
                adp.Fill(ds)
                csList.Close()
                ddChain.DataSource = ds.Tables(0)
                ddChain.DataTextField = "ListIndex"
                ddChain.DataValueField = "Code"
                ddChain.DataBind()
                ddChain.Items.Insert(0, "---select value---")
                If rsNV("Chain Name").ToString() = "" Then
                    ddChain.SelectedIndex = 0
                Else
                    For Count = 0 To ddChain.Items.Count - 1
                        If ddChain.Items(Count).Value.ToString() = (rsNV("Chain Name").ToString()) Then
                            ddChain.SelectedIndex = Count
                        End If
                    Next Count
                End If

                ddUseLoc.Focus()
                OGUseLoc.Value = rsNV("Usage Location").ToString()
                OGShipLoc.Value = rsNV("Shipping Location").ToString()
                OGPayType.Value = rsNV("Shipping Payment Type")
                OGFreeFrt.Value = rsNV("Free Freight")
                OGBackorder.Value = rsNV("Backorder")
                OGShipAgent.Value = rsNV("Shipping Agent Code").ToString()
                OGEShip.Value = rsNV("E-Ship Agent Service").ToString()
                OGShipMeth.Value = rsNV("Shipment Method Code").ToString()
                OGPriceCode.Value = rsNV("Customer Price Code").ToString()
                OGPriceGroup.Value = rsNV("Customer Price Group").ToString()
                OGDiscGroup.Value = rsNV("Customer Disc_ Group").ToString()
                OGInsideSales.Value = rsNV("Inside Salesperson").ToString()
                OGChain.Value = rsNV("Chain Name").ToString()
                CustLabel.Text = "Original Value:"
            End While
        Else
            lblCustNo.Text = txtCustNo.Text
            lblCustDesc.Text = "Customer Not On File"
            CurVal.Text = ""
            txtCustNo.Focus()
        End If

        txtCustNo.Text = ""

        rsNV.Close()
    End Sub

    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnUpdate.Click
        If txtCustNo.Text = "" Then
            txtCustNo.Text = lblCustNo.Text
        End If

        '---Make sure that UNSELECTED values are set to BLANK
        If ddUseLoc.SelectedValue.ToString() = "---select value---" Then
            updUseLoc = ""
        Else
            updUseLoc = ddUseLoc.SelectedValue.ToString()
        End If

        If ddShipLoc.SelectedValue.ToString() = "---select value---" Then
            updShipLoc = ""
        Else
            updShipLoc = ddShipLoc.SelectedValue.ToString()
        End If

        If ddShipAgent.SelectedValue.ToString() = "---select value---" Then
            updShipAgent = ""
        Else
            updShipAgent = ddShipAgent.SelectedValue.ToString()
        End If

        If ddEShipAgent.SelectedValue.ToString() = "---select value---" Then
            updEShip = ""
        Else
            updEShip = ddEShipAgent.SelectedValue.ToString()
        End If

        If ddShipMeth.SelectedValue.ToString() = "---select value---" Then
            updShipMeth = ""
        Else
            updShipMeth = ddShipMeth.SelectedValue.ToString()
        End If

        If ddPriceGroup.SelectedValue.ToString() = "---select value---" Then
            updPriceGroup = ""
        Else
            updPriceGroup = ddPriceGroup.SelectedValue.ToString()
        End If

        If ddDiscGroup.SelectedValue.ToString() = "---select value---" Then
            updDiscGroup = ""
        Else
            updDiscGroup = ddDiscGroup.SelectedValue.ToString()
        End If

        If ddInsideSales.SelectedValue.ToString() = "---select value---" Then
            updInsideSales = ""
        Else
            updInsideSales = ddInsideSales.SelectedValue.ToString()
        End If

        If ddChain.SelectedValue.ToString() = "---select value---" Then
            updChain = ""
        Else
            updChain = ddChain.SelectedValue.ToString()
        End If

        '---Update NewVision
        updNV.CommandText = "UPDATE [Porteous$Customer] SET "
        updNV.CommandText = updNV.CommandText & "[Usage Location]='" & updUseLoc & "', "
        updNV.CommandText = updNV.CommandText & "[Shipping Location]='" & updShipLoc & "', "
        updNV.CommandText = updNV.CommandText & "[Shipping Payment Type]='" & ddShipPayType.SelectedValue.ToString() & "', "
        updNV.CommandText = updNV.CommandText & "[Free Freight]='" & ddFreeFrt.SelectedValue.ToString() & "', "
        updNV.CommandText = updNV.CommandText & "[Backorder]='" & ddBackorder.SelectedValue.ToString() & "', "
        updNV.CommandText = updNV.CommandText & "[Shipping Agent Code]='" & updShipAgent & "', "
        updNV.CommandText = updNV.CommandText & "[E-Ship Agent Service]='" & updEShip & "', "
        updNV.CommandText = updNV.CommandText & "[Shipment Method Code]='" & updShipMeth & "', "
        updNV.CommandText = updNV.CommandText & "[Customer Price Code]='" & UCase(txtPriceCode.Text) & "', "
        updNV.CommandText = updNV.CommandText & "[Customer Price Group]='" & updPriceGroup & "', "
        updNV.CommandText = updNV.CommandText & "[Customer Disc_ Group]='" & updDiscGroup & "', "
        updNV.CommandText = updNV.CommandText & "[Inside Salesperson]='" & updInsideSales & "', "
        updNV.CommandText = updNV.CommandText & "[Chain Name]='" & updChain & "' "
        updNV.CommandText = updNV.CommandText & "WHERE ([No_] = '" & txtCustNo.Text & "')"
        'Response.Write(updNV.CommandText.ToString())

        updNV.Connection = csNV
        csNV.Open()
        updNV.ExecuteNonQuery()
        csNV.Close()

        '---Update ERP
        '---Only ABCCd & CustSearchKey are currently UPDATED
        updERP.CommandText = "UPDATE [CustomerMaster] SET "
        'updERP.CommandText = updERP.CommandText & "[ShipViaCd]='" & updShipAgent & "', "
        'updERP.CommandText = updERP.CommandText & "[ShipMethCd]='" & updShipMeth & "', "
        updERP.CommandText = updERP.CommandText & "[ABCCd]='" & UCase(txtPriceCode.Text) & "', "
        updERP.CommandText = updERP.CommandText & "[CustSearchKey]='" & updChain & "' "
        updERP.CommandText = updERP.CommandText & "WHERE ([CustNo] = '" & txtCustNo.Text & "')"
        'Response.Write(updERP.CommandText.ToString())

        updERP.Connection = csERP
        csERP.Open()
        updERP.ExecuteNonQuery()
        csERP.Close()

        rsRead()
        txtCustNo.Focus()
        CustLabel.Text = "Customer Updated"

    End Sub

    Protected Sub btnCancel_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles btnCancel.Click
        Response.Redirect("MaintCustCard.aspx")
    End Sub

    Protected Sub ddShipAgent_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddShipAgent.SelectedIndexChanged
        '---Update the E-Ship Agent DropDown when Ship Agent is changed
        If ddShipAgent.SelectedValue <> "" Then
            adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, [Shipping Agent Code], Description, (Case WHEN (UPPER(Description) <> UPPER(Code)) THEN [Shipping Agent Code] + ' - ' + UPPER(Description) + ' (' + UPPER(Code) + ')' ELSE [Shipping Agent Code] + ' - ' + UPPER(Description) END) as ListIndex FROM [Porteous$E-Ship Agent Service] WHERE [World Wide Service]='0' AND [Shipping Agent Code] = '" & ddShipAgent.SelectedValue & "' ORDER BY Code", csList)
        Else
            adp.SelectCommand = New Data.SqlClient.SqlCommand("SELECT Code, [Shipping Agent Code], Description, (Case WHEN (UPPER(Description) <> UPPER(Code)) THEN [Shipping Agent Code] + ' - ' + UPPER(Description) + ' (' + UPPER(Code) + ')' ELSE [Shipping Agent Code] + ' - ' + UPPER(Description) END) as ListIndex FROM [Porteous$E-Ship Agent Service] WHERE [World Wide Service]='0' ORDER BY Code", csList)
        End If
        adp.Fill(ds)
        csList.Close()
        ddEShipAgent.DataSource = ds.Tables(0)
        ddEShipAgent.DataTextField = "ListIndex"
        ddEShipAgent.DataValueField = "Code"
        ddEShipAgent.DataBind()
        ddEShipAgent.Items.Insert(0, "---select value---")
        ddEShipAgent.SelectedIndex = 0
    End Sub

End Class

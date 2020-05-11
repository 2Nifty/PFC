using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using ShipLive;
using System.Data.SqlClient;
using System.Data;

using PFC.SOE.DataAccessLayer;
using PFC.SOE.Securitylayer; 

/// <summary>
/// Summary description for FreightCalculator
/// </summary>
public class FreightCalculator
{
    #region variable declaration
    private const string SP_GENERALSELECT = "UGEN_SP_SELECT";
    private const string SP_SELECT = "DTQ_SP_SELECT";
    private const string SP_GENERALINSERT = "UGEN_SP_INSERT";
    private const string SDKINTERNALUSER = "INTERNAL";
    private const string SP_GENERALUPDATE = "UGEN_SP_UPDATE";
    #endregion

    public enum CarrierType
    {
        UPSRed, //UPSNextDayAir, 
        UPSBlue, //UPS2ndDayAir
        UPSGround, // UPS
    }

    public double GetFreightRate(string shipperFirstName,string shipperlastName, string shipperAddressline1,string shipperCity,string shipperState,string shipperPostalCode,string shipperCountry,string shipperPhone,
                                string shipToFirstName,string shipTolastName, string shipToAddressline1, string shipToCity, string shipToState, string shipToPostalCode, string shipToCountry, string shipToPhone,
                               string carrierType, string packageWeight)
    {
        SLRequest slReq = new SLRequest();
        Request oRequest = new Request();
        string[] carriers = { carrierType }; //define a valid carrier
        oRequest.CarriersToActOn = carriers;
        oRequest.ShipTransaction = new ShipTransaction();
        Shipment oShipment = new Shipment();
        oRequest.ShipTransaction.Shipment = oShipment;
        ShipperAddress oShipperAddress = new ShipperAddress();
        oShipperAddress.Address = new Address();
        SLXmlAttribute slXmlShipFirstName = new SLXmlAttribute();
        slXmlShipFirstName.Value = shipperFirstName;
        oShipperAddress.Address.FirstName = slXmlShipFirstName;

        SLXmlAttribute slXmlShipLastName = new SLXmlAttribute();
        slXmlShipLastName.Value = shipperlastName;
        oShipperAddress.Address.LastName = slXmlShipLastName;

        SLXmlAttribute slXmlShipAddress1 = new SLXmlAttribute();
        slXmlShipAddress1.Value = shipperAddressline1;
        oShipperAddress.Address.Address1 = slXmlShipAddress1;

        SLXmlAttribute slXmlShipShipCity = new SLXmlAttribute();
        slXmlShipShipCity.Value = shipperCity;
        oShipperAddress.Address.City = slXmlShipShipCity;

        SLXmlAttribute slXmlShipState = new SLXmlAttribute();
        slXmlShipState.Value = shipperState;
        oShipperAddress.Address.State = slXmlShipState;

        SLXmlAttribute slXmlShipPostCode = new SLXmlAttribute();
        slXmlShipPostCode.Value = shipperPostalCode;
        oShipperAddress.Address.PostalCode = slXmlShipPostCode;

        SLXmlAttribute slXmlShipCountry = new SLXmlAttribute();
        slXmlShipCountry.Value = shipperCountry;
        oShipperAddress.Address.Country = slXmlShipCountry;

        SLXmlAttribute slXmlShipPhone = new SLXmlAttribute();
        slXmlShipPhone.Value = shipperPhone;
        oShipperAddress.Address.Phone = slXmlShipPhone; 
        
        oRequest.ShipTransaction.Shipment.ShipperAddress  = oShipperAddress;
        DeliveryAddress oDeliveryAddress = new DeliveryAddress();
        oDeliveryAddress.Address = new Address();

        SLXmlAttribute slXmlDeliverFirstName = new SLXmlAttribute();
        slXmlDeliverFirstName.Value = shipToFirstName;
        oDeliveryAddress.Address.FirstName = slXmlDeliverFirstName;

        SLXmlAttribute slXmlDeliverLastName = new SLXmlAttribute();
        slXmlDeliverLastName.Value = shipTolastName;
        oDeliveryAddress.Address.LastName = slXmlDeliverLastName;

        SLXmlAttribute slXmlDeliverAddres1 = new SLXmlAttribute();
        slXmlDeliverAddres1.Value = shipToAddressline1 ;
        oDeliveryAddress.Address.Address1 = slXmlDeliverAddres1;

        SLXmlAttribute slXmlDeliverCity = new SLXmlAttribute();
        slXmlDeliverCity.Value = shipToCity;
        oDeliveryAddress.Address.City = slXmlDeliverCity;

        SLXmlAttribute slXmlDeliverState = new SLXmlAttribute();
        slXmlDeliverState.Value = shipToState;
        oDeliveryAddress.Address.State = slXmlDeliverState;

        SLXmlAttribute slXmlDeliverPostalCode = new SLXmlAttribute();
        slXmlDeliverPostalCode.Value = shipToPostalCode;
        oDeliveryAddress.Address.PostalCode = slXmlDeliverPostalCode;

        SLXmlAttribute slXmlDeliverCountry = new SLXmlAttribute();
        slXmlDeliverCountry.Value = shipToCountry;
        oDeliveryAddress.Address.Country = slXmlDeliverCountry;

        SLXmlAttribute slXmlDeliverPhone = new SLXmlAttribute();
        slXmlDeliverPhone.Value = shipToPhone;
        oDeliveryAddress.Address.Phone = slXmlDeliverPhone;
        oRequest.ShipTransaction.Shipment.DeliveryAddress = oDeliveryAddress;

        oRequest.Settings = new Settings();

        Package oPkg = new Package();
        SLXmlAttribute slXmlPackage = new SLXmlAttribute();
        slXmlPackage.Value = packageWeight;
        oPkg.PackageActualWeight = slXmlPackage;
        Package[] oPkgArr = new Package[] { oPkg };
        oRequest.ShipTransaction.Shipment.Package = oPkgArr;
        slReq.Request = oRequest;
        SLResponse slResp = null;
        try
        {
            ShippingLiveService srvc = new ShippingLiveService();
            slResp = srvc.RateShipment(slReq);
            if (slResp.ResultList != null)
            {
                return slResp.ResultList[0].TotalCharge;
            }

            return 0;
        }
        catch (Exception ex)
        {
            return 0;
        //exception handling here
        }
    }

    public bool GetFreightAddressEval(string shipperAddressline1, string shipperCity, string shipperState, string shipperPostalCode,
                                string shipToAddressline1, string shipToCity, string shipToState, string shipToPostalCode)
    {

        SLRequest slReq = new SLRequest();
        Request oRequest = new Request();
        //string[] carriers = { carrierType }; //define a valid carrier
        //oRequest.CarriersToActOn = carriers;
        oRequest.ShipTransaction = new ShipTransaction();
        Shipment oShipment = new Shipment();
        oRequest.ShipTransaction.Shipment = oShipment;
        ShipperAddress oShipperAddress = new ShipperAddress();
        oShipperAddress.Address = new Address();
        SLXmlAttribute slXmlShipFirstName = new SLXmlAttribute();
        slXmlShipFirstName.Value = "";
        oShipperAddress.Address.FirstName = slXmlShipFirstName;

        SLXmlAttribute slXmlShipLastName = new SLXmlAttribute();
        slXmlShipLastName.Value = "";
        oShipperAddress.Address.LastName = slXmlShipLastName;

        SLXmlAttribute slXmlShipAddress1 = new SLXmlAttribute();
        slXmlShipAddress1.Value = shipperAddressline1;
        oShipperAddress.Address.Address1 = slXmlShipAddress1;

        SLXmlAttribute slXmlShipShipCity = new SLXmlAttribute();
        slXmlShipShipCity.Value = shipperCity;
        oShipperAddress.Address.City = slXmlShipShipCity;

        SLXmlAttribute slXmlShipState = new SLXmlAttribute();
        slXmlShipState.Value = shipperState;
        oShipperAddress.Address.State = slXmlShipState;

        SLXmlAttribute slXmlShipPostCode = new SLXmlAttribute();
        slXmlShipPostCode.Value = shipperPostalCode;
        oShipperAddress.Address.PostalCode = slXmlShipPostCode;

        SLXmlAttribute slXmlShipCountry = new SLXmlAttribute();
        slXmlShipCountry.Value = "";
        oShipperAddress.Address.Country = slXmlShipCountry;

        SLXmlAttribute slXmlShipPhone = new SLXmlAttribute();
        slXmlShipPhone.Value = "";
        oShipperAddress.Address.Phone = slXmlShipPhone;

        oRequest.ShipTransaction.Shipment.ShipperAddress = oShipperAddress;
        DeliveryAddress oDeliveryAddress = new DeliveryAddress();
        oDeliveryAddress.Address = new Address();

        SLXmlAttribute slXmlDeliverFirstName = new SLXmlAttribute();
        slXmlDeliverFirstName.Value = "";
        oDeliveryAddress.Address.FirstName = slXmlDeliverFirstName;

        SLXmlAttribute slXmlDeliverLastName = new SLXmlAttribute();
        slXmlDeliverLastName.Value = "";
        oDeliveryAddress.Address.LastName = slXmlDeliverLastName;

        SLXmlAttribute slXmlDeliverAddres1 = new SLXmlAttribute();
        slXmlDeliverAddres1.Value = shipToAddressline1;
        oDeliveryAddress.Address.Address1 = slXmlDeliverAddres1;

        SLXmlAttribute slXmlDeliverCity = new SLXmlAttribute();
        slXmlDeliverCity.Value = shipToCity;
        oDeliveryAddress.Address.City = slXmlDeliverCity;

        SLXmlAttribute slXmlDeliverState = new SLXmlAttribute();
        slXmlDeliverState.Value = shipToState;
        oDeliveryAddress.Address.State = slXmlDeliverState;

        SLXmlAttribute slXmlDeliverPostalCode = new SLXmlAttribute();
        slXmlDeliverPostalCode.Value = shipToPostalCode;
        oDeliveryAddress.Address.PostalCode = slXmlDeliverPostalCode;

        SLXmlAttribute slXmlDeliverCountry = new SLXmlAttribute();
        slXmlDeliverCountry.Value = "";
        oDeliveryAddress.Address.Country = slXmlDeliverCountry;

        SLXmlAttribute slXmlDeliverPhone = new SLXmlAttribute();
        slXmlDeliverPhone.Value = "";
        oDeliveryAddress.Address.Phone = slXmlDeliverPhone;
        oRequest.ShipTransaction.Shipment.DeliveryAddress = oDeliveryAddress;

        Package oPkg = new Package();
        SLXmlAttribute slXmlPackage = new SLXmlAttribute();
        slXmlPackage.Value = "2";
        oPkg.PackageActualWeight = slXmlPackage;
        Package[] oPkgArr = new Package[] { oPkg };
        oRequest.ShipTransaction.Shipment.Package = oPkgArr;
        slReq.Request = oRequest;
        SLResponse slResp = null;
        try
        {
            bool addResult, addResSpec;
            ShippingLiveService srvc = new ShippingLiveService();
            srvc.ValidateAddress(slReq, out addResult, out addResSpec);
            string a = "xyz";
            //  slResp = srvc.RateShipment(slReq);
            //if (slResp.ResultList != null)
            //{
            //    return slResp.ResultList[0].TotalCharge;
            //}


            return addResult;


        }
        catch (Exception ex)
        {
            return false;
            //exception handling here
        }
    }    

    public string GetCarrierCode(CarrierType carrierType)
    {

        switch (carrierType)
        {
            case CarrierType.UPSRed:
                return "UPS2";
                break;
            //case CarrierType.UPSNextDayAir_Early_AM:
            //    return "14";
            //    break;
            //case CarrierType.UPSNextDayAirSaver:
            //    return "13";
            //    break;
            case CarrierType.UPSBlue:
                return "UPS3";
                break;
            //case CarrierType.UPS2ndDayAir_AM:
            //    return "59";
            //    break;
            //case CarrierType.UPS3DaySelect:
            //    return "12";
            //    break;
            case CarrierType.UPSGround:
                return "UPSG";
                break;
        }

        return "05";
    }

    public string GetCarrier(string carrierType)
    {
        if (carrierType == "UPS Blue – 2 Day Delv")
            carrierType = "UPS Blue";
        else if (carrierType == "UPS Red – Next Day Delv")
        {
            carrierType = "UPS RED";
            return carrierType;
        }
        else if (carrierType == "UPS Red – Early Delv")
            carrierType = "UPS Early";

        switch (carrierType)
        {
            //case "UPS Red":
            //    return "UPSN";
            //    break;
            case "UPS Blue":
                return "UPS2";
                break;
            case "UPS Orange":
                return "UPS3";
                break;
            case "UPS Early":
                return "UPSNXA";
                break;
            case "UPS": //
                return "UPSG";
                break;
            case "LTL":
                return "LTL";
                break;

        }
        return "05";
    }

    public DataSet selectFreightCriteria()
    {
        try
        {
            // Local variable declaration
            string _tableName = "AppPref";
            string _columnName = "AppOptionValue, AppOptionNumber";
            string _whereClause = "ApplicationCd='WSOE' and AppOptionType= 'WebFreight'";

            DataSet dsCCdetails = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, SP_GENERALSELECT,
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereCondition", _whereClause));

            // Check whether any value has returned
            if (dsCCdetails.Tables[0] != null)
                return dsCCdetails;
            else
                return null;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public bool IsValidTruckRouteAvailable(string fromLoc, string toLoc)
    {
        try
        {

            DataSet dsRoutedetails = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pWOEGetTruckRoutes]",
                                new SqlParameter("@fromLoc", fromLoc),
                                new SqlParameter("@toLoc", toLoc));

            // Check whether any value has returned
            if (dsRoutedetails.Tables[0] != null && dsRoutedetails.Tables[0].Rows.Count >0)
                return true;
            else
                return false;
        }
        catch (Exception ex)
        {
            return false;
        }
    } 
}

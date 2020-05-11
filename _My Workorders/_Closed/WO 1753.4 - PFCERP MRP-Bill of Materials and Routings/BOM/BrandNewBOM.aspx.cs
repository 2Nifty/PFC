#region Insert New or Update Record

    private void UpdateOrAddNewRecord(string ID, string Company, string Name, string Title, string Address, string Country, bool isUpdate)

    {

        SqlConnection connection = new SqlConnection(GetConnectionString());

        string sqlStatement = string.Empty;

 

        if (!isUpdate)

        {

            sqlStatement = "INSERT INTO Customers"+

"(CustomerID,CompanyName,ContactName,ContactTitle,Address,Country)" +

"VALUES (@CustomerID,@CompanyName,@ContactName,@ContactTitle,@Address,@Country)";

        }

        else

        {

            sqlStatement = "UPDATE Customers" +

                           "SET CompanyName = @CompanyName,

                           ContactName = @ContactName," +

                           "ContactTitle = @ContactTitle,Address =  

                           @Address,Country = @Country" +

                           "WHERE CustomerID = @CustomerID,";

        }

        try

        {

            connection.Open();

            SqlCommand cmd = new SqlCommand(sqlStatement, connection);

            cmd.Parameters.AddWithValue("@CustomerID", ID);

            cmd.Parameters.AddWithValue("@CompanyName", Company);

            cmd.Parameters.AddWithValue("@ContactName", Name);

            cmd.Parameters.AddWithValue("@ContactTitle", Title);

            cmd.Parameters.AddWithValue("@Address", Address);

            cmd.Parameters.AddWithValue("@Country", Country);

            cmd.CommandType = CommandType.Text;

            cmd.ExecuteNonQuery();

        }

        catch (System.Data.SqlClient.SqlException ex)

        {

            string msg = "Insert/Update Error:";

            msg += ex.Message;

            throw new Exception(msg);

 

        }

        finally

        {

            connection.Close();

        }

    }

    #endregion

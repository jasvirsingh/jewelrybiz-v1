using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace JewelryBiz.DataAccess.Core
{
    public class SqlDataAccess
    {
        // Default connection string. a connection named MsSql should be defined in web.config file.
        public const string CONNECTION_STRING_NAME = "JewelryBizCon";

        //This returns the connection string  
        private static string _connectionString = string.Empty;
        public static string ConnectionString
        {
            get
            {
                if (_connectionString == string.Empty)
                {
                    _connectionString = ConfigurationManager.ConnectionStrings[CONNECTION_STRING_NAME].ConnectionString;
                }
                return _connectionString;
            }
        }

        /// <summary>
        /// Brings a SqlCommand object to be able to add some parameters in it. After you send this to Execute method.
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public SqlCommand GetCommand(string sql)
        {
            SqlConnection conn = new SqlConnection(ConnectionString);
            SqlCommand sqlCmd = new SqlCommand(sql, conn);
            return sqlCmd;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public DataTable Execute(string sql)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = GetCommand(sql);
            if (cmd.Connection.State == ConnectionState.Closed)
            {
                cmd.Connection.Open();
            }
            dt.Load(cmd.ExecuteReader());
            cmd.Connection.Close();
            return dt;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="command"></param>
        /// <returns></returns>
        public DataTable Execute(SqlCommand command)
        {
            DataTable dt = new DataTable();
            if (command.Connection.State == ConnectionState.Closed)
            {
                command.Connection.Open();
            }
            //command.ExecuteNonQuery();
            dt.Load(command.ExecuteReader());
            command.Connection.Close();
            return dt;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sql"></param>
        /// <returns></returns>
        public int ExecuteNonQuery(string sql)
        {
            SqlCommand cmd = GetCommand(sql);
            if (cmd.Connection.State == ConnectionState.Closed)
            {
                cmd.Connection.Open();
            }
            int result = cmd.ExecuteNonQuery();
            cmd.Connection.Close();
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="command"></param>
        /// <returns></returns>
        public int ExecuteNonQuery(SqlCommand command)
        {
            if (command.Connection.State == ConnectionState.Closed)
            {
                command.Connection.Open();
            }
            int result = command.ExecuteNonQuery();
            command.Connection.Close();
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="spName"></param>
        /// <returns></returns>
        public int ExecuteStoredProcedure(string spName)
        {
            SqlCommand cmd = GetCommand(spName);
            cmd.CommandType = CommandType.StoredProcedure;
            if (cmd.Connection.State == ConnectionState.Closed)
            {
                cmd.Connection.Open();
            }
            int result = cmd.ExecuteNonQuery();
            cmd.Connection.Close();
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="spName"></param>
        /// <returns></returns>
        public int ExecuteNonQuery(string spName, SqlParameter[] sqlParameters)
        {
            SqlCommand cmd = GetCommand(spName);
            cmd.CommandType = CommandType.StoredProcedure;
            if (cmd.Connection.State == ConnectionState.Closed)
            {
                cmd.Connection.Open();
            }
            cmd.Parameters.AddRange(sqlParameters);
            int result = cmd.ExecuteNonQuery();
            cmd.Connection.Close();
            return result;
        }

        private SqlConnection GetConnection(string connectionName)
        {
            string cnstr = ConfigurationManager.ConnectionStrings[connectionName].ConnectionString;
            SqlConnection cn = new SqlConnection(cnstr);
            cn.Open();
            return cn;
        }

        public DataSet ExecuteStoredProcedure(string storedProcName, SqlParameter[] sqlParameters)
        {
            DataSet ds = new DataSet();
            using (SqlConnection cn = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = cn.CreateCommand())
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = storedProcName;
                    // assign parameters passed in to the command
                    if (sqlParameters != null)
                    {
                        cmd.Parameters.AddRange(sqlParameters);
                    }
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(ds);
                    }
                }
            }
            return ds;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="command"></param>
        /// <returns></returns>
        public int ExecuteStoredProcedure(SqlCommand command)
        {
            command.CommandType = CommandType.StoredProcedure;
            if (command.Connection.State == ConnectionState.Closed)
            {
                command.Connection.Open();
            }
            int result = command.ExecuteNonQuery();
            command.Connection.Close();
            return result;
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

namespace QLCT.DAO
{
    public class Connect
    {
        protected SqlConnection getConnection = new SqlConnection(@"Data Source=TREF4R;Initial Catalog=DA_QLCT;Integrated Security=True");
    }
}
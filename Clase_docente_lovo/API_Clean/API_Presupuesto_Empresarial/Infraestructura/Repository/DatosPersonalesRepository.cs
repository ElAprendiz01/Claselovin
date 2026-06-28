using Aplicacion.Interfaces;
using Domain.DatosPersonales;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class DatosPersonalesRepository : IDatosPersonalesRepository
    {
        private readonly DBconexionfactory _connection;

        public DatosPersonalesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_catalogo

        public async Task<DBResult> Crear_Cat_DatosPersonalesAsync(DM_DatosPersonales_crear modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Datos_Personales_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Genero", modelo.Id_Genero ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Primer_Nombre", modelo.Primer_Nombre ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Segundo_Nombre", modelo.Segundo_Nombre ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Primer_Apellido", modelo.Primer_Apellido ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Segundo_Apellido", modelo.Segundo_Apellido ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Fecha_Nacimiento", modelo.Fecha_Nacimiento ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Tipo_DNI", modelo.Id_Tipo_DNI ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@DNI", modelo.DNI ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Creador", modelo.Id_Creador ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Estado", modelo.Id_Estado ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pTemplate = new SqlParameter("@o_templateId", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pTemplate);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al crear el registro de datos personales.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el registro.", ex);
            }
        }

        public async Task<DBResult> Actualizar_Cat_DatosPersonalesAsync(DM_DatosPersonales_actualizar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Datos_Personales_Actualizar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Persona", modelo.Id_Persona ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Genero", modelo.Id_Genero ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Primer_Nombre", modelo.Primer_Nombre ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Segundo_Nombre", modelo.Segundo_Nombre ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Primer_Apellido", modelo.Primer_Apellido ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Segundo_Apellido", modelo.Segundo_Apellido ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Fecha_Nacimiento", modelo.Fecha_Nacimiento ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Tipo_DNI", modelo.Id_Tipo_DNI ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@DNI", modelo.DNI ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Modificador", modelo.Id_Modificador ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Estado", modelo.Id_Estado ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@ForzarRecuperacion", modelo.ForzarRecuperacion ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pTemplate = new SqlParameter("@o_templateId", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pTemplate);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al actualizar el registro de datos personales.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el registro.", ex);
            }
        }

        public async Task<DBResult> Eliminar_Cat_DatosPersonalesAsync(DM_DatosPersonales_eliminar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Datos_Personales_Eliminar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Persona", modelo.Id_Persona ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Modificador", modelo.Id_Modificador ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pTemplate = new SqlParameter("@o_templateId", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pTemplate);

                    await cmd.ExecuteNonQueryAsync();

                    result.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    result.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    result.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return result;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el registro de datos personales.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el registro.", ex);
            }
        }

        #endregion

        #region lectura_catalogo

        public async Task<IEnumerable<DM_DatosPersonales_listar>> Listar_Cat_DatosPersonalesAsync()
        {
            var list = new List<DM_DatosPersonales_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Datos_Personales_Listar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(MapearDataReaderADominio(dr));
                        }
                    }
                }
                return list;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al consultar el listado de datos personales en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_DatosPersonales_listar>> Filtrar_Cat_DatosPersonalesAsync(DM_DatosPersonales_filtrar modelo)
        {
            var list = new List<DM_DatosPersonales_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Datos_Personales_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Persona", modelo.Id_Persona ?? (object)DBNull.Value));

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            list.Add(MapearDataReaderADominio(dr));
                        }
                    }
                }
                return list;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al filtrar la lista de datos personales en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_DatosPersonales_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            var schema = dr.GetSchemaTable();
            var columns = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            foreach (DataRow row in schema.Rows)
            {
                columns.Add(row["ColumnName"].ToString()!);
            }

            var item = new DM_DatosPersonales_listar();

            item.Id_Persona = dr["Id_Persona"] as int?;
            item.Primer_Nombre = dr["Primer_Nombre"]?.ToString();
            item.Segundo_Nombre = dr["Segundo_Nombre"]?.ToString();
            item.Primer_Apellido = dr["Primer_Apellido"]?.ToString();
            item.Segundo_Apellido = dr["Segundo_Apellido"]?.ToString();
            item.DNI = dr["DNI"]?.ToString();
            item.Id_Tipo_DNI = dr["Id_Tipo_DNI"] as int?;
            item.Nombre_Tipo_DNI = dr["Nombre_Tipo_DNI"]?.ToString();
            item.Id_Genero = dr["Id_Genero"] as int?;
            item.Nombre_Genero = dr["Nombre_Genero"]?.ToString();
            item.Fecha_Nacimiento = dr["Fecha_Nacimiento"] as DateTime?;
            item.Id_Estado = dr["Id_Estado"] as int?;
            item.Nombre_Estado = dr["Nombre_Estado"]?.ToString();
            item.Id_Creador = dr["Id_Creador"] as int?;
            item.Id_Modificador = dr["Id_Modificador"] as int?;
            item.Fecha_Creacion = dr["Fecha_Creacion"] as DateTime?;
            item.Fecha_Modificacion = dr["Fecha_Modificacion"] as DateTime?;

            if (columns.Contains("Nombre_Completo"))
            {
                item.Nombre_Completo = dr["Nombre_Completo"]?.ToString();
            }

            return item;
        }

        #endregion
    }
}

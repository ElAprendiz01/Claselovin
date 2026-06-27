using Aplicacion.Interfaces;
using Domain.Rol;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class RolRepository : IRolRepository
    {
        private readonly DBconexionfactory _connection;

        public RolRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_catalogo

        public async Task<DBResult> Crear_Cat_RolesAsync(DM_Rol_crear modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Roles_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Nombre", modelo.Nombre ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Descripcion", modelo.Descripcion ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al crear el rol del catálogo.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el rol.", ex);
            }
        }

        public async Task<DBResult> Actualizar_Cat_RolesAsync(DM_Rol_actualizar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Roles_Actualizar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Rol", modelo.Id_Rol ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Nombre", modelo.Nombre ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Descripcion", modelo.Descripcion ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el rol del catálogo.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el rol.", ex);
            }
        }

        public async Task<DBResult> Eliminar_Cat_RolesAsync(DM_Rol_eliminar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Roles_Eliminar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Rol", modelo.Id_Rol ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al eliminar de forma lógica el rol.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el rol.", ex);
            }
        }

        #endregion

        #region lectura_catalogo

        public async Task<IEnumerable<DM_Rol_listar>> Listar_Cat_RolesAsync()
        {
            var list = new List<DM_Rol_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Roles_Listar", con))
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
                throw new Exception("Error al consultar el listado de roles en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Rol_listar>> Filtrar_Cat_RolesAsync(DM_Rol_filtrar modelo)
        {
            var list = new List<DM_Rol_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Roles_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Rol", modelo.Id_Rol ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar la lista de roles en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_Rol_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            return new DM_Rol_listar
            {
                Id_Rol = dr["Id_Rol"] as int?,
                Nombre = dr["Nombre"]?.ToString(),
                Descripcion = dr["Descripcion"]?.ToString(),
                Fecha_Creacion = dr["Fecha_Creacion"] as DateTime?,
                Fecha_Modificacion = dr["Fecha_Modificacion"] as DateTime?,
                Id_Creador = dr["Id_Creador"] as int?,
                Id_Modificador = dr["Id_Modificador"] as int?,
                Id_Estado = dr["Id_Estado"] as int?,
                Nombre_Estado = dr["Nombre_Estado"]?.ToString()
            };
        }

        #endregion
    }
}

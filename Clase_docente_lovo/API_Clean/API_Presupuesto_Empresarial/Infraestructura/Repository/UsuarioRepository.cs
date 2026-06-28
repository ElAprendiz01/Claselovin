using Aplicacion.Interfaces;
using Domain.Usuario;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class UsuarioRepository : IUsuarioRepository
    {
        private readonly DBconexionfactory _connection;

        public UsuarioRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_catalogo

        public async Task<DBResult> Crear_Cat_UsuariosAsync(DM_Usuario_crear modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Usuarios_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Usuario", modelo.Usuario ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Contrasena", modelo.Contrasena ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Persona", modelo.Id_Persona ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Rol", modelo.Id_Rol ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al crear el usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el usuario.", ex);
            }
        }

        public async Task<DBResult> Actualizar_Cat_UsuariosAsync(DM_Usuario_actualizar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Usuarios_Actualizar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Usuario", modelo.Id_Usuario ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Usuario", modelo.Usuario ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Contrasena", modelo.Contrasena ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Persona", modelo.Id_Persona ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Rol", modelo.Id_Rol ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el usuario.", ex);
            }
        }

        public async Task<DBResult> Eliminar_Cat_UsuariosAsync(DM_Usuario_eliminar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Usuarios_Eliminar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Usuario", modelo.Id_Usuario ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al eliminar el usuario.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el usuario.", ex);
            }
        }

        #endregion

        #region lectura_catalogo

        public async Task<IEnumerable<DM_Usuario_listar>> Listar_Cat_UsuariosAsync()
        {
            var list = new List<DM_Usuario_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Usuarios_Listar", con))
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
                throw new Exception("Error al consultar el listado de usuarios en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Usuario_listar>> Filtrar_Cat_UsuariosAsync(DM_Usuario_filtrar modelo)
        {
            var list = new List<DM_Usuario_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Usuarios_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Usuario", modelo.Id_Usuario ?? (object)DBNull.Value));
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
                throw new Exception("Error al filtrar la lista de usuarios en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_Usuario_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            return new DM_Usuario_listar
            {
                Id_Usuario = dr["Id_Usuario"] as int?,
                Usuario = dr["Usuario"]?.ToString(),
                Id_Persona = dr["Id_Persona"] as int?,
                Nombre_Completo = dr["Nombre_Completo"]?.ToString(),
                DNI = dr["DNI"]?.ToString(),
                Id_Rol = dr["Id_Rol"] as int?,
                Nombre_Rol = dr["Nombre_Rol"]?.ToString(),
                Id_Estado = dr["Id_Estado"] as int?,
                Nombre_Estado = dr["Nombre_Estado"]?.ToString(),
                Id_Creador = dr["Id_Creador"] as int?,
                Id_Modificador = dr["Id_Modificador"] as int?,
                Fecha_Creacion = dr["Fecha_Creacion"] as DateTime?,
                Fecha_Modificacion = dr["Fecha_Modificacion"] as DateTime?
            };
        }

        #endregion
    }
}

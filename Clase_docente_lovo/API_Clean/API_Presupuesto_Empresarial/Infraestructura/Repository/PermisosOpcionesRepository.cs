using Aplicacion.Interfaces;
using Domain.PermisosOpciones;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class PermisosOpcionesRepository : IPermisosOpcionesRepository
    {
        private readonly DBconexionfactory _connection;

        public PermisosOpcionesRepository(DBconexionfactory connection)
        {
            _connection = connection;
        }

        #region escritura_catalogo

        public async Task<DBResult> Crear_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_crear modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Permisos_Opciones_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Rol", modelo.Id_Rol ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Modulo", modelo.Modulo ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Crear", modelo.Puede_Crear ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Leer", modelo.Puede_Leer ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Actualizar", modelo.Puede_Actualizar ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Eliminar", modelo.Puede_Eliminar ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Creador", modelo.Id_Creador ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al crear el permiso de opción.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el permiso.", ex);
            }
        }

        public async Task<DBResult> Actualizar_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_actualizar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Permisos_Opciones_Actualizar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Permiso", modelo.Id_Permiso ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Rol", modelo.Id_Rol ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Modulo", modelo.Modulo ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Crear", modelo.Puede_Crear ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Leer", modelo.Puede_Leer ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Actualizar", modelo.Puede_Actualizar ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Puede_Eliminar", modelo.Puede_Eliminar ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al actualizar el permiso de opción.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el permiso.", ex);
            }
        }

        public async Task<DBResult> Eliminar_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_eliminar modelo)
        {
            var result = new DBResult();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Permisos_Opciones_Eliminar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Permiso", modelo.Id_Permiso ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Usuario_Ejecutor", modelo.Id_Usuario_Ejecutor ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar el permiso de opción.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el permiso.", ex);
            }
        }

        #endregion

        #region lectura_catalogo

        public async Task<IEnumerable<DM_PermisosOpciones_listar>> Listar_Cat_PermisosOpcionesAsync()
        {
            var list = new List<DM_PermisosOpciones_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Permisos_Opciones_Listar", con))
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
                throw new Exception("Error al consultar el listado de permisos en la base de datos.", ex);
            }
        }

        public async Task<IEnumerable<DM_PermisosOpciones_listar>> Filtrar_Cat_PermisosOpcionesAsync(DM_PermisosOpciones_filtrar modelo)
        {
            var list = new List<DM_PermisosOpciones_listar>();
            try
            {
                using var con = _connection.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Permisos_Opciones_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Permiso", modelo.Id_Permiso ?? (object)DBNull.Value));
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
                throw new Exception("Error al filtrar la lista de permisos en la base de datos.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_PermisosOpciones_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            return new DM_PermisosOpciones_listar
            {
                Id_Permiso = dr["Id_Permiso"] as int?,
                Id_Rol = dr["Id_Rol"] as int?,
                Nombre_Rol = dr["Nombre_Rol"]?.ToString(),
                Modulo = dr["Modulo"]?.ToString(),
                Puede_Crear = dr["Puede_Crear"] as bool?,
                Puede_Leer = dr["Puede_Leer"] as bool?,
                Puede_Actualizar = dr["Puede_Actualizar"] as bool?,
                Puede_Eliminar = dr["Puede_Eliminar"] as bool?,
                Fecha_Creacion = dr["Fecha_Creacion"] as DateTime?,
                Id_Creador = dr["Id_Creador"] as int?
            };
        }

        #endregion
    }
}

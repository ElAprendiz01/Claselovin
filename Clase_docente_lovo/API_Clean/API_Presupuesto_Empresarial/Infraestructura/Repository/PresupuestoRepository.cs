using Aplicacion.Interfaces;
using Domain.Presupuesto;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class PresupuestoRepository : IPresupuestoRepository
    {
        private readonly DBconexionfactory _conexion;

        public PresupuestoRepository(DBconexionfactory conexion)
        {
            _conexion = conexion;
        }

        #region escritura_presupuesto

        public async Task<DBResult> Crear_PresupuestoAsync(DM_Presupuesto_crear modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Presupuestos_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Anio_Fiscal", modelo.Anio_Fiscal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Moneda", modelo.Id_Moneda ?? (object)DBNull.Value));
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

                    resultado.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    resultado.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    resultado.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return resultado;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al crear el presupuesto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el presupuesto.", ex);
            }
        }

        public async Task<DBResult> Actualizar_PresupuestoAsync(DM_Presupuesto_actualizar modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Presupuestos_Actualizar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto", modelo.Id_Presupuesto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Anio_Fiscal", modelo.Anio_Fiscal ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Moneda", modelo.Id_Moneda ?? (object)DBNull.Value));
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

                    resultado.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    resultado.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    resultado.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return resultado;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al actualizar el presupuesto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el presupuesto.", ex);
            }
        }

        public async Task<DBResult> Eliminar_PresupuestoAsync(DM_Presupuesto_eliminar modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Presupuestos_Eliminar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto", modelo.Id_Presupuesto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Modificador", modelo.Id_Modificador ?? (object)DBNull.Value));

                    SqlParameter pCode = new SqlParameter("@o_code", SqlDbType.Int) { Direction = ParameterDirection.Output };
                    SqlParameter pMessage = new SqlParameter("@o_message", SqlDbType.VarChar, 255) { Direction = ParameterDirection.Output };
                    SqlParameter pTemplate = new SqlParameter("@o_templateId", SqlDbType.Int) { Direction = ParameterDirection.Output };

                    cmd.Parameters.Add(pCode);
                    cmd.Parameters.Add(pMessage);
                    cmd.Parameters.Add(pTemplate);

                    await cmd.ExecuteNonQueryAsync();

                    resultado.Code = pCode.Value != DBNull.Value ? (int?)pCode.Value : null;
                    resultado.Message = pMessage.Value != DBNull.Value ? pMessage.Value.ToString() : null;
                    resultado.TemplateId = pTemplate.Value != DBNull.Value ? (int?)pTemplate.Value : null;
                }
                return resultado;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error en el motor SQL al eliminar el presupuesto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el presupuesto.", ex);
            }
        }

        #endregion

        #region lectura_presupuesto

        public async Task<IEnumerable<DM_Presupuesto_listar>> Listar_PresupuestoAsync()
        {
            var lista = new List<DM_Presupuesto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Presupuestos_Listar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            lista.Add(MapearDataReaderADominio(dr));
                        }
                    }
                }
                return lista;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al consultar el listado completo de presupuestos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Presupuesto_listar>> Filtrar_PresupuestoAsync(DM_Presupuesto_filtrar modelo)
        {
            var lista = new List<DM_Presupuesto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Presupuestos_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto", modelo.Id_Presupuesto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Anio_Fiscal", modelo.Anio_Fiscal ?? (object)DBNull.Value));

                    using (SqlDataReader dr = await cmd.ExecuteReaderAsync())
                    {
                        while (await dr.ReadAsync())
                        {
                            lista.Add(MapearDataReaderADominio(dr));
                        }
                    }
                }
                return lista;
            }
            catch (SqlException ex)
            {
                throw new Exception("Error al filtrar la lista de presupuestos.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_Presupuesto_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            return new DM_Presupuesto_listar
            {
                Id_Presupuesto = dr["Id_Presupuesto"] as int?,
                Anio_Fiscal = dr["Anio_Fiscal"] as int?,
                Id_Moneda = dr["Id_Moneda"] as int?,
                Codigo_ISO = dr["Codigo_ISO"]?.ToString(),
                Nombre_Moneda = dr["Nombre_Moneda"]?.ToString(),
                Simbolo = dr["Simbolo"]?.ToString(),
                Descripcion = dr["Descripcion"]?.ToString(),
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

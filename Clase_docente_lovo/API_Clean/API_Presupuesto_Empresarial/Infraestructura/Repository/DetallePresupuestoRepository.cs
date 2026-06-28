using Aplicacion.Interfaces;
using Domain.DetallePresupuesto;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class DetallePresupuestoRepository : IDetallePresupuestoRepository
    {
        private readonly DBconexionfactory _conexion;

        public DetallePresupuestoRepository(DBconexionfactory conexion)
        {
            _conexion = conexion;
        }

        #region escritura_detalle_presupuesto

        public async Task<DBResult> Crear_DetallePresupuestoAsync(DM_DetallePresupuesto_crear modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Detalle_Presupuesto_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto", modelo.Id_Presupuesto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Centro_Costo", modelo.Id_Centro_Costo ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Categoria_Gasto", modelo.Id_Categoria_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Monto_Presupuestado", modelo.Monto_Presupuestado ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Creador", modelo.Id_Creador ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al crear el detalle del presupuesto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el detalle del presupuesto.", ex);
            }
        }

        public async Task<DBResult> Actualizar_DetallePresupuestoAsync(DM_DetallePresupuesto_actualizar modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Detalle_Presupuesto_Actualizar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto_Detalle", modelo.Id_Presupuesto_Detalle ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Monto_Presupuestado", modelo.Monto_Presupuestado ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el detalle del presupuesto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el detalle del presupuesto.", ex);
            }
        }

        public async Task<DBResult> Eliminar_DetallePresupuestoAsync(DM_DetallePresupuesto_eliminar modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Detalle_Presupuesto_Eliminar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto_Detalle", modelo.Id_Presupuesto_Detalle ?? (object)DBNull.Value));

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
                throw new Exception("Error en el motor SQL al eliminar el detalle del presupuesto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el detalle del presupuesto.", ex);
            }
        }

        #endregion

        #region lectura_detalle_presupuesto

        public async Task<IEnumerable<DM_DetallePresupuesto_listar>> Listar_DetallePresupuestoAsync()
        {
            var lista = new List<DM_DetallePresupuesto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Detalle_Presupuesto_Listar", con))
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
                throw new Exception("Error al consultar el listado completo del detalle del presupuesto.", ex);
            }
        }

        public async Task<IEnumerable<DM_DetallePresupuesto_listar>> Filtrar_DetallePresupuestoAsync(DM_DetallePresupuesto_filtrar modelo)
        {
            var lista = new List<DM_DetallePresupuesto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Detalle_Presupuesto_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto_Detalle", modelo.Id_Presupuesto_Detalle ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto", modelo.Id_Presupuesto ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar el detalle del presupuesto.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_DetallePresupuesto_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            return new DM_DetallePresupuesto_listar
            {
                Id_Presupuesto_Detalle = dr["Id_Presupuesto_Detalle"] as int?,
                Id_Presupuesto = dr["Id_Presupuesto"] as int?,
                Anio_Fiscal = dr["Anio_Fiscal"] as int?,
                Id_Centro_Costo = dr["Id_Centro_Costo"] as int?,
                Nombre_Centro = dr["Nombre_Centro"]?.ToString(),
                Codigo_Contable = dr["Codigo_Contable"]?.ToString(),
                Id_Departamento = dr["Id_Departamento"] as int?,
                Nombre_Departamento = dr["Nombre_Departamento"]?.ToString(),
                Id_Categoria_Gasto = dr["Id_Categoria_Gasto"] as int?,
                Nombre_Categoria_Gasto = dr["Nombre_Categoria_Gasto"]?.ToString(),
                Monto_Presupuestado = dr["Monto_Presupuestado"] as decimal?,
                Monto_Ejecutado = dr["Monto_Ejecutado"] as decimal?,
                Saldo_Disponible = dr["Saldo_Disponible"] as decimal?,
                Id_Creador = dr["Id_Creador"] as int?,
                Id_Modificador = dr["Id_Modificador"] as int?,
                Fecha_Creacion = dr["Fecha_Creacion"] as DateTime?,
                Fecha_Modificacion = dr["Fecha_Modificacion"] as DateTime?
            };
        }

        #endregion
    }
}

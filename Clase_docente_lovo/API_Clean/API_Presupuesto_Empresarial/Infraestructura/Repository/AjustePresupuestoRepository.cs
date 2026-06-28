using Aplicacion.Interfaces;
using Domain.AjustePresupuesto;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class AjustePresupuestoRepository : IAjustePresupuestoRepository
    {
        private readonly DBconexionfactory _conexion;

        public AjustePresupuestoRepository(DBconexionfactory conexion)
        {
            _conexion = conexion;
        }

        #region escritura_ajuste_presupuesto

        public async Task<DBResult> Crear_AjustePresupuestoAsync(DM_AjustePresupuesto_crear modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Ajustes_Presupuesto_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto_Detalle", modelo.Id_Presupuesto_Detalle ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Tipo_Ajuste", modelo.Tipo_Ajuste ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Monto_Ajuste", modelo.Monto_Ajuste ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Justificacion", modelo.Justificacion ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al crear el ajuste de presupuesto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el ajuste de presupuesto.", ex);
            }
        }

        #endregion

        #region lectura_ajuste_presupuesto

        public async Task<IEnumerable<DM_AjustePresupuesto_listar>> Listar_AjustePresupuestoAsync()
        {
            var lista = new List<DM_AjustePresupuesto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Ajustes_Presupuesto_Listar", con))
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
                throw new Exception("Error al consultar el listado completo de ajustes de presupuesto.", ex);
            }
        }

        public async Task<IEnumerable<DM_AjustePresupuesto_listar>> Filtrar_AjustePresupuestoAsync(DM_AjustePresupuesto_filtrar modelo)
        {
            var lista = new List<DM_AjustePresupuesto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Ajustes_Presupuesto_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Ajuste", modelo.Id_Ajuste ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto_Detalle", modelo.Id_Presupuesto_Detalle ?? (object)DBNull.Value));

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
                throw new Exception("Error al filtrar los ajustes de presupuesto.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_AjustePresupuesto_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            return new DM_AjustePresupuesto_listar
            {
                Id_Ajuste = dr["Id_Ajuste"] as int?,
                Id_Presupuesto_Detalle = dr["Id_Presupuesto_Detalle"] as int?,
                Id_Presupuesto = dr["Id_Presupuesto"] as int?,
                Anio_Fiscal = dr["Anio_Fiscal"] as int?,
                Nombre_Centro = dr["Nombre_Centro"]?.ToString(),
                Nombre_Categoria_Gasto = dr["Nombre_Categoria_Gasto"]?.ToString(),
                Tipo_Ajuste = dr["Tipo_Ajuste"]?.ToString(),
                Monto_Ajuste = dr["Monto_Ajuste"] as decimal?,
                Justificacion = dr["Justificacion"]?.ToString(),
                Fecha_Ajuste = dr["Fecha_Ajuste"] as DateTime?,
                Id_Creador = dr["Id_Creador"] as int?
            };
        }

        #endregion
    }
}

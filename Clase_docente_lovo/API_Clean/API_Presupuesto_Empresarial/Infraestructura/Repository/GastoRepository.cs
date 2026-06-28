using Aplicacion.Interfaces;
using Domain.Gasto;
using Domain.VariablesSalida;
using Infraestructura.DB;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;

namespace Infraestructura.Repository
{
    public class GastoRepository : IGastoRepository
    {
        private readonly DBconexionfactory _conexion;

        public GastoRepository(DBconexionfactory conexion)
        {
            _conexion = conexion;
        }

        #region escritura_gasto

        public async Task<DBResult> Crear_GastoAsync(DM_Gasto_crear modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Gastos_Crear", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Presupuesto_Detalle", modelo.Id_Presupuesto_Detalle ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Tipo_Gasto", modelo.Id_Tipo_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Descripcion_Gasto", modelo.Descripcion_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Monto_Gasto", modelo.Monto_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Fecha_Gasto", modelo.Fecha_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Numero_Factura", modelo.Numero_Factura ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Proveedor", modelo.Id_Proveedor ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al crear el gasto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al crear el gasto.", ex);
            }
        }

        public async Task<DBResult> Actualizar_GastoAsync(DM_Gasto_actualizar modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Gastos_Actualizar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Gasto", modelo.Id_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Tipo_Gasto", modelo.Id_Tipo_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Descripcion_Gasto", modelo.Descripcion_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Monto_Gasto", modelo.Monto_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Fecha_Gasto", modelo.Fecha_Gasto ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Numero_Factura", modelo.Numero_Factura ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Proveedor", modelo.Id_Proveedor ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al actualizar el gasto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al actualizar el gasto.", ex);
            }
        }

        public async Task<DBResult> Eliminar_GastoAsync(DM_Gasto_eliminar modelo)
        {
            var resultado = new DBResult();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Gastos_Eliminar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Id_Gasto", modelo.Id_Gasto ?? (object)DBNull.Value));
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
                throw new Exception("Error en el motor SQL al eliminar el gasto.", ex);
            }
            catch (Exception ex)
            {
                throw new Exception("Error crítico de infraestructura al eliminar el gasto.", ex);
            }
        }

        #endregion

        #region lectura_gasto

        public async Task<IEnumerable<DM_Gasto_listar>> Listar_GastoAsync()
        {
            var lista = new List<DM_Gasto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Gastos_Listar", con))
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
                throw new Exception("Error al consultar el listado completo de gastos.", ex);
            }
        }

        public async Task<IEnumerable<DM_Gasto_listar>> Filtrar_GastoAsync(DM_Gasto_filtrar modelo)
        {
            var lista = new List<DM_Gasto_listar>();
            try
            {
                using var con = _conexion.CreateConnection();
                await con.OpenAsync();

                using (SqlCommand cmd = new SqlCommand("sp_Tbl_Gastos_Filtrar", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@SearchTerm", modelo.SearchTerm ?? (object)DBNull.Value));
                    cmd.Parameters.Add(new SqlParameter("@Id_Gasto", modelo.Id_Gasto ?? (object)DBNull.Value));
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
                throw new Exception("Error al filtrar la lista de gastos.", ex);
            }
        }

        #endregion

        #region mapeo

        private DM_Gasto_listar MapearDataReaderADominio(SqlDataReader dr)
        {
            return new DM_Gasto_listar
            {
                Id_Gasto = dr["Id_Gasto"] as int?,
                Descripcion_Gasto = dr["Descripcion_Gasto"]?.ToString(),
                Monto_Gasto = dr["Monto_Gasto"] as decimal?,
                Fecha_Gasto = dr["Fecha_Gasto"] as DateTime?,
                Numero_Factura = dr["Numero_Factura"]?.ToString(),
                Id_Proveedor = dr["Id_Proveedor"] as int?,
                Proveedor = dr["Proveedor"]?.ToString(),
                Id_Tipo_Gasto = dr["Id_Tipo_Gasto"] as int?,
                Tipo_Gasto = dr["Tipo_Gasto"]?.ToString(),
                Id_Presupuesto_Detalle = dr["Id_Presupuesto_Detalle"] as int?,
                Id_Presupuesto = dr["Id_Presupuesto"] as int?,
                Anio_Fiscal = dr["Anio_Fiscal"] as int?,
                Nombre_Centro = dr["Nombre_Centro"]?.ToString(),
                Nombre_Departamento = dr["Nombre_Departamento"]?.ToString(),
                Id_Estado = dr["Id_Estado"] as int?,
                Nombre_Estado = dr["Nombre_Estado"]?.ToString(),
                Id_Creador = dr["Id_Creador"] as int?,
                Fecha_Creacion = dr["Fecha_Creacion"] as DateTime?
            };
        }

        #endregion
    }
}

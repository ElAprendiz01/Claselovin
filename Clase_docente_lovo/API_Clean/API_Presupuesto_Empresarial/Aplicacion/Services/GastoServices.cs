using Aplicacion.DTOs.Gasto;
using Aplicacion.Interfaces;
using Domain.Gasto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class GastoServices
    {
        private readonly IGastoRepository _repositorio;

        public GastoServices(IGastoRepository repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<IEnumerable<DM_Gasto_listar>> Listar_Gasto_Async()
        {
            return await _repositorio.Listar_GastoAsync();
        }

        public async Task<IEnumerable<DM_Gasto_listar>> Filtrar_Gasto_Async(GastoFiltrarDTOs dto)
        {
            var modelo = new DM_Gasto_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Gasto = dto.Id_Gasto,
                Id_Presupuesto_Detalle = dto.Id_Presupuesto_Detalle
            };
            return await _repositorio.Filtrar_GastoAsync(modelo);
        }

        public async Task<DBResult> Crear_Gasto_Async(GastoCrearDTOs dto)
        {
            var modelo = new DM_Gasto_crear
            {
                Id_Presupuesto_Detalle = dto.Id_Presupuesto_Detalle,
                Id_Tipo_Gasto = dto.Id_Tipo_Gasto,
                Descripcion_Gasto = dto.Descripcion_Gasto,
                Monto_Gasto = dto.Monto_Gasto,
                Fecha_Gasto = dto.Fecha_Gasto,
                Numero_Factura = dto.Numero_Factura,
                Id_Proveedor = dto.Id_Proveedor,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repositorio.Crear_GastoAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Gasto_Async(GastoActualizarDTOs dto)
        {
            var modelo = new DM_Gasto_actualizar
            {
                Id_Gasto = dto.Id_Gasto,
                Id_Tipo_Gasto = dto.Id_Tipo_Gasto,
                Descripcion_Gasto = dto.Descripcion_Gasto,
                Monto_Gasto = dto.Monto_Gasto,
                Fecha_Gasto = dto.Fecha_Gasto,
                Numero_Factura = dto.Numero_Factura,
                Id_Proveedor = dto.Id_Proveedor,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repositorio.Actualizar_GastoAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Gasto_Async(GastoEliminarDTOs dto)
        {
            var modelo = new DM_Gasto_eliminar
            {
                Id_Gasto = dto.Id_Gasto,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repositorio.Eliminar_GastoAsync(modelo);
        }
    }
}

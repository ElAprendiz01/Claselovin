using Aplicacion.DTOs.DetallePresupuesto;
using Aplicacion.Interfaces;
using Domain.DetallePresupuesto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class DetallePresupuestoServices
    {
        private readonly IDetallePresupuestoRepository _repositorio;

        public DetallePresupuestoServices(IDetallePresupuestoRepository repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<IEnumerable<DM_DetallePresupuesto_listar>> Listar_DetallePresupuesto_Async()
        {
            return await _repositorio.Listar_DetallePresupuestoAsync();
        }

        public async Task<IEnumerable<DM_DetallePresupuesto_listar>> Filtrar_DetallePresupuesto_Async(DetallePresupuestoFiltrarDTOs dto)
        {
            var modelo = new DM_DetallePresupuesto_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Presupuesto_Detalle = dto.Id_Presupuesto_Detalle,
                Id_Presupuesto = dto.Id_Presupuesto
            };
            return await _repositorio.Filtrar_DetallePresupuestoAsync(modelo);
        }

        public async Task<DBResult> Crear_DetallePresupuesto_Async(DetallePresupuestoCrearDTOs dto)
        {
            var modelo = new DM_DetallePresupuesto_crear
            {
                Id_Presupuesto = dto.Id_Presupuesto,
                Id_Centro_Costo = dto.Id_Centro_Costo,
                Id_Categoria_Gasto = dto.Id_Categoria_Gasto,
                Monto_Presupuestado = dto.Monto_Presupuestado,
                Id_Creador = dto.Id_Creador
            };
            return await _repositorio.Crear_DetallePresupuestoAsync(modelo);
        }

        public async Task<DBResult> Actualizar_DetallePresupuesto_Async(DetallePresupuestoActualizarDTOs dto)
        {
            var modelo = new DM_DetallePresupuesto_actualizar
            {
                Id_Presupuesto_Detalle = dto.Id_Presupuesto_Detalle,
                Monto_Presupuestado = dto.Monto_Presupuestado,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repositorio.Actualizar_DetallePresupuestoAsync(modelo);
        }

        public async Task<DBResult> Eliminar_DetallePresupuesto_Async(DetallePresupuestoEliminarDTOs dto)
        {
            var modelo = new DM_DetallePresupuesto_eliminar
            {
                Id_Presupuesto_Detalle = dto.Id_Presupuesto_Detalle
            };
            return await _repositorio.Eliminar_DetallePresupuestoAsync(modelo);
        }
    }
}

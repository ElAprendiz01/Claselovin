using Aplicacion.DTOs.Presupuesto;
using Aplicacion.Interfaces;
using Domain.Presupuesto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class PresupuestoServices
    {
        private readonly IPresupuestoRepository _repositorio;

        public PresupuestoServices(IPresupuestoRepository repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<IEnumerable<DM_Presupuesto_listar>> Listar_Presupuesto_Async()
        {
            return await _repositorio.Listar_PresupuestoAsync();
        }

        public async Task<IEnumerable<DM_Presupuesto_listar>> Filtrar_Presupuesto_Async(PresupuestoFiltrarDTOs dto)
        {
            var modelo = new DM_Presupuesto_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Presupuesto = dto.Id_Presupuesto,
                Anio_Fiscal = dto.Anio_Fiscal
            };
            return await _repositorio.Filtrar_PresupuestoAsync(modelo);
        }

        public async Task<DBResult> Crear_Presupuesto_Async(PresupuestoCrearDTOs dto)
        {
            var modelo = new DM_Presupuesto_crear
            {
                Anio_Fiscal = dto.Anio_Fiscal,
                Id_Moneda = dto.Id_Moneda,
                Descripcion = dto.Descripcion,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repositorio.Crear_PresupuestoAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Presupuesto_Async(PresupuestoActualizarDTOs dto)
        {
            var modelo = new DM_Presupuesto_actualizar
            {
                Id_Presupuesto = dto.Id_Presupuesto,
                Anio_Fiscal = dto.Anio_Fiscal,
                Id_Moneda = dto.Id_Moneda,
                Descripcion = dto.Descripcion,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repositorio.Actualizar_PresupuestoAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Presupuesto_Async(PresupuestoEliminarDTOs dto)
        {
            var modelo = new DM_Presupuesto_eliminar
            {
                Id_Presupuesto = dto.Id_Presupuesto,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repositorio.Eliminar_PresupuestoAsync(modelo);
        }
    }
}

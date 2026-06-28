using Aplicacion.DTOs.AjustePresupuesto;
using Aplicacion.Interfaces;
using Domain.AjustePresupuesto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class AjustePresupuestoServices
    {
        private readonly IAjustePresupuestoRepository _repositorio;

        public AjustePresupuestoServices(IAjustePresupuestoRepository repositorio)
        {
            _repositorio = repositorio;
        }

        public async Task<IEnumerable<DM_AjustePresupuesto_listar>> Listar_AjustePresupuesto_Async()
        {
            return await _repositorio.Listar_AjustePresupuestoAsync();
        }

        public async Task<IEnumerable<DM_AjustePresupuesto_listar>> Filtrar_AjustePresupuesto_Async(AjustePresupuestoFiltrarDTOs dto)
        {
            var modelo = new DM_AjustePresupuesto_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Ajuste = dto.Id_Ajuste,
                Id_Presupuesto_Detalle = dto.Id_Presupuesto_Detalle
            };
            return await _repositorio.Filtrar_AjustePresupuestoAsync(modelo);
        }

        public async Task<DBResult> Crear_AjustePresupuesto_Async(AjustePresupuestoCrearDTOs dto)
        {
            var modelo = new DM_AjustePresupuesto_crear
            {
                Id_Presupuesto_Detalle = dto.Id_Presupuesto_Detalle,
                Tipo_Ajuste = dto.Tipo_Ajuste,
                Monto_Ajuste = dto.Monto_Ajuste,
                Justificacion = dto.Justificacion,
                Id_Creador = dto.Id_Creador
            };
            return await _repositorio.Crear_AjustePresupuestoAsync(modelo);
        }
    }
}

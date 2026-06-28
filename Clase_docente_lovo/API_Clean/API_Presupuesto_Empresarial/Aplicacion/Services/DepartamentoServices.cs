using Aplicacion.DTOs.Departamento;
using Aplicacion.Interfaces;
using Domain.Departamento;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class DepartamentoServices
    {
        private readonly IDepartamentoRepository _repository;

        public DepartamentoServices(IDepartamentoRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Departamento_listar>> Listar_Cat_Departamentos_Async()
        {
            return await _repository.Listar_Cat_DepartamentosAsync();
        }

        public async Task<IEnumerable<DM_Departamento_listar>> Filtrar_Cat_Departamentos_Async(DepartamentoFiltrarDTOs dto)
        {
            var modelo = new DM_Departamento_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Departamento = dto.Id_Departamento
            };
            return await _repository.Filtrar_Cat_DepartamentosAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_Departamentos_Async(DepartamentoCrearDTOs dto)
        {
            var modelo = new DM_Departamento_crear
            {
                Nombre_Departamento = dto.Nombre_Departamento,
                Codigo_Softland = dto.Codigo_Softland,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repository.Crear_Cat_DepartamentosAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_Departamentos_Async(DepartamentoActualizarDTOs dto)
        {
            var modelo = new DM_Departamento_actualizar
            {
                Id_Departamento = dto.Id_Departamento,
                Nombre_Departamento = dto.Nombre_Departamento,
                Codigo_Softland = dto.Codigo_Softland,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Actualizar_Cat_DepartamentosAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_Departamentos_Async(DepartamentoEliminarDTOs dto)
        {
            var modelo = new DM_Departamento_eliminar
            {
                Id_Departamento = dto.Id_Departamento,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_DepartamentosAsync(modelo);
        }
    }
}

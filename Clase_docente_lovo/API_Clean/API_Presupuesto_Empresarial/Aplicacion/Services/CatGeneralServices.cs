using Aplicacion.DTOs.CatalogoGeneral;
using Aplicacion.Interfaces;
using Domain.CatalogoGeneral;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class CatGeneralServices
    {
        private readonly ICatGeneralRepository _repository;

        public CatGeneralServices(ICatGeneralRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Cat_General_listar>> Listar_Cat_General_Async()
        {
            return await _repository.Listar_Cat_GeneralAsync();
        }

        public async Task<IEnumerable<DM_Cat_General_listar>> Filtrar_Cat_General_Async(CatGeneralFiltrarDTOs dto)
        {
            var modelo = new DM_Cat_General_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Catalogo = dto.Id_Catalogo,
                Id_Tipo_Catalogo = dto.Id_Tipo_Catalogo
            };
            return await _repository.Filtrar_Cat_GeneralAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_General_Async(CatGeneralCrearDTOs dto)
        {
            var modelo = new DM_Cat_General_crear
            {
                Id_Tipo_Catalogo = dto.Id_Tipo_Catalogo,
                Nombre = dto.Nombre,
                Id_Creador = dto.Id_Creador
            };
            return await _repository.Crear_Cat_GeneralAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_General_Async(CatGeneralActualizarDTOs dto)
        {
            var modelo = new DM_Cat_General_actualizar
            {
                Id_Catalogo = dto.Id_Catalogo,
                Id_Tipo_Catalogo = dto.Id_Tipo_Catalogo,
                Nombre = dto.Nombre,
                Id_Modificador = dto.Id_Modificador,
                Activo = dto.Activo
            };
            return await _repository.Actualizar_Cat_GeneralAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_General_Async(CatGeneralEliminarDTOs dto)
        {
            var modelo = new DM_Cat_General_eliminar
            {
                Id_Catalogo = dto.Id_Catalogo,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_GeneralAsync(modelo);
        }
    }
}

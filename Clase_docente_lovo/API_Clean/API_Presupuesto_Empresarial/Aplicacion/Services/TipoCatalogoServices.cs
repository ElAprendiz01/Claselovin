using Aplicacion.DTOs.TipoCatalogo;
using Aplicacion.Interfaces;
using Domain.TipoCatalogo;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class TipoCatalogoServices
    {
        private readonly ITipoCatalogoRepository _repository;

        public TipoCatalogoServices(ITipoCatalogoRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Tipo_Catalogo_listar>> Listar_Cat_Tipo_Catalogo_Async()
        {
            return await _repository.Listar_Cat_Tipo_CatalogoAsync();
        }

        public async Task<IEnumerable<DM_Tipo_Catalogo_listar>> Filtrar_Cat_Tipo_Catalogo_Async(TipoCatalogoFiltrarDTOs dto)
        {
            var modelo = new DM_Tipo_Catalogo_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Tipo_Catalogo = dto.Id_Tipo_Catalogo
            };
            return await _repository.Filtrar_Cat_Tipo_CatalogoAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_Tipo_Catalogo_Async(TipoCatalogoCrearDTOs dto)
        {
            var modelo = new DM_Tipo_Catalogo_crear
            {
                Nombre = dto.Nombre,
                Id_Creador = dto.Id_Creador
            };
            return await _repository.Crear_Cat_Tipo_CatalogoAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_Tipo_Catalogo_Async(TipoCatalogoActualizarDTOs dto)
        {
            var modelo = new DM_Tipo_Catalogo_actualizar
            {
                Id_Tipo_Catalogo = dto.Id_Tipo_Catalogo,
                Nombre = dto.Nombre,
                Id_Modificador = dto.Id_Modificador,
                Activo = dto.Activo
            };
            return await _repository.Actualizar_Cat_Tipo_CatalogoAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_Tipo_Catalogo_Async(TipoCatalogoEliminarDTOs dto)
        {
            var modelo = new DM_Tipo_Catalogo_eliminar
            {
                Id_Tipo_Catalogo = dto.Id_Tipo_Catalogo,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_Tipo_CatalogoAsync(modelo);
        }
    }
}

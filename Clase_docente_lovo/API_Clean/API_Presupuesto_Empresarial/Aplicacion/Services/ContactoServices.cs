using Aplicacion.DTOs.Contacto;
using Aplicacion.Interfaces;
using Domain.Contacto;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class ContactoServices
    {
        private readonly IContactoRepository _repository;

        public ContactoServices(IContactoRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_Contacto_listar>> Listar_Cat_Contacto_Async()
        {
            return await _repository.Listar_Cat_ContactoAsync();
        }

        public async Task<DBResult> Crear_Cat_Contacto_Async(ContactoCrearDTOs dto)
        {
            var modelo = new DM_Contacto_crear
            {
                Id_Persona = dto.Id_Persona,
                Id_Tipo_Contacto = dto.Id_Tipo_Contacto,
                Contacto = dto.Contacto,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repository.Crear_Cat_ContactoAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_Contacto_Async(ContactoActualizarDTOs dto)
        {
            var modelo = new DM_Contacto_actualizar
            {
                Id_Contacto = dto.Id_Contacto,
                Id_Persona = dto.Id_Persona,
                Id_Tipo_Contacto = dto.Id_Tipo_Contacto,
                Contacto = dto.Contacto,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Actualizar_Cat_ContactoAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_Contacto_Async(ContactoEliminarDTOs dto)
        {
            var modelo = new DM_Contacto_eliminar
            {
                Id_Contacto = dto.Id_Contacto,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_ContactoAsync(modelo);
        }
    }
}

using Aplicacion.DTOs.DatosPersonales;
using Aplicacion.Interfaces;
using Domain.DatosPersonales;
using Domain.VariablesSalida;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Aplicacion.Services
{
    public class DatosPersonalesServices
    {
        private readonly IDatosPersonalesRepository _repository;

        public DatosPersonalesServices(IDatosPersonalesRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<DM_DatosPersonales_listar>> Listar_Cat_DatosPersonales_Async()
        {
            return await _repository.Listar_Cat_DatosPersonalesAsync();
        }

        public async Task<IEnumerable<DM_DatosPersonales_listar>> Filtrar_Cat_DatosPersonales_Async(DatosPersonalesFiltrarDTOs dto)
        {
            var modelo = new DM_DatosPersonales_filtrar
            {
                SearchTerm = dto.SearchTerm,
                Id_Persona = dto.Id_Persona
            };
            return await _repository.Filtrar_Cat_DatosPersonalesAsync(modelo);
        }

        public async Task<DBResult> Crear_Cat_DatosPersonales_Async(DatosPersonalesCrearDTOs dto)
        {
            var modelo = new DM_DatosPersonales_crear
            {
                Id_Genero = dto.Id_Genero,
                Primer_Nombre = dto.Primer_Nombre,
                Segundo_Nombre = dto.Segundo_Nombre,
                Primer_Apellido = dto.Primer_Apellido,
                Segundo_Apellido = dto.Segundo_Apellido,
                Fecha_Nacimiento = dto.Fecha_Nacimiento,
                Id_Tipo_DNI = dto.Id_Tipo_DNI,
                DNI = dto.DNI,
                Id_Creador = dto.Id_Creador,
                Id_Estado = dto.Id_Estado
            };
            return await _repository.Crear_Cat_DatosPersonalesAsync(modelo);
        }

        public async Task<DBResult> Actualizar_Cat_DatosPersonales_Async(DatosPersonalesActualizarDTOs dto)
        {
            var modelo = new DM_DatosPersonales_actualizar
            {
                Id_Persona = dto.Id_Persona,
                Id_Genero = dto.Id_Genero,
                Primer_Nombre = dto.Primer_Nombre,
                Segundo_Nombre = dto.Segundo_Nombre,
                Primer_Apellido = dto.Primer_Apellido,
                Segundo_Apellido = dto.Segundo_Apellido,
                Fecha_Nacimiento = dto.Fecha_Nacimiento,
                Id_Tipo_DNI = dto.Id_Tipo_DNI,
                DNI = dto.DNI,
                Id_Modificador = dto.Id_Modificador,
                Id_Estado = dto.Id_Estado,
                ForzarRecuperacion = dto.ForzarRecuperacion
            };
            return await _repository.Actualizar_Cat_DatosPersonalesAsync(modelo);
        }

        public async Task<DBResult> Eliminar_Cat_DatosPersonales_Async(DatosPersonalesEliminarDTOs dto)
        {
            var modelo = new DM_DatosPersonales_eliminar
            {
                Id_Persona = dto.Id_Persona,
                Id_Modificador = dto.Id_Modificador
            };
            return await _repository.Eliminar_Cat_DatosPersonalesAsync(modelo);
        }
    }
}

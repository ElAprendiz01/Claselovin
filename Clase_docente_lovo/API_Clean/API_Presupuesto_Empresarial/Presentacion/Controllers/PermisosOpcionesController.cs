using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.PermisosOpciones;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PermisosOpcionesController : ControllerBase
    {
        private readonly PermisosOpcionesServices _service;

        public PermisosOpcionesController(PermisosOpcionesServices service)
        {
            _service = service;
        }

        #region lectura_catalogo

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Cat_PermisosOpciones()
        {
            try
            {
                var lista = await _service.Listar_Cat_PermisosOpciones_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron permisos de opciones." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_Cat_PermisosOpciones([FromBody] PermisosOpcionesFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _service.Filtrar_Cat_PermisosOpciones_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron permisos que coincidan con la búsqueda." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion

        #region escritura_catalogo

        [HttpPost("crear")]
        public async Task<IActionResult> Crear_Cat_PermisosOpciones([FromBody] PermisosOpcionesCrearDTOs permisos)
        {
            try
            {
                if (!ModelState.IsValid || permisos == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _service.Crear_Cat_PermisosOpciones_Async(permisos);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPut("actualizar")]
        public async Task<IActionResult> Actualizar_Cat_PermisosOpciones([FromBody] PermisosOpcionesActualizarDTOs permisos)
        {
            try
            {
                if (permisos == null || !permisos.Id_Permiso.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del permiso es obligatorio." });
                }

                DBResult resultado = await _service.Actualizar_Cat_PermisosOpciones_Async(permisos);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpDelete("eliminar")]
        public async Task<IActionResult> Eliminar_Cat_PermisosOpciones([FromBody] PermisosOpcionesEliminarDTOs permisos)
        {
            try
            {
                if (permisos == null || !permisos.Id_Permiso.HasValue || !permisos.Id_Usuario_Ejecutor.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del permiso y el ID del usuario ejecutor son requeridos." });
                }

                DBResult resultado = await _service.Eliminar_Cat_PermisosOpciones_Async(permisos);

                if (!resultado.IsSuccess)
                {
                    return BadRequest(new { codigo = resultado.Code, msj = resultado.Message });
                }

                return Ok(new { codigo = resultado.Code, msj = resultado.Message, templateId = resultado.TemplateId });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        #endregion
    }
}

using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.Contacto;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ContactoController : ControllerBase
    {
        private readonly ContactoServices _service;

        public ContactoController(ContactoServices service)
        {
            _service = service;
        }

        #region lectura_catalogo

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Cat_Contacto()
        {
            try
            {
                var lista = await _service.Listar_Cat_Contacto_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron contactos." });
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
        public async Task<IActionResult> Crear_Cat_Contacto([FromBody] ContactoCrearDTOs contacto)
        {
            try
            {
                if (!ModelState.IsValid || contacto == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _service.Crear_Cat_Contacto_Async(contacto);

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
        public async Task<IActionResult> Actualizar_Cat_Contacto([FromBody] ContactoActualizarDTOs contacto)
        {
            try
            {
                if (contacto == null || !contacto.Id_Contacto.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del contacto es obligatorio." });
                }

                DBResult resultado = await _service.Actualizar_Cat_Contacto_Async(contacto);

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
        public async Task<IActionResult> Eliminar_Cat_Contacto([FromBody] ContactoEliminarDTOs contacto)
        {
            try
            {
                if (contacto == null || !contacto.Id_Contacto.HasValue || !contacto.Id_Modificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del contacto y el ID del modificador son requeridos." });
                }

                DBResult resultado = await _service.Eliminar_Cat_Contacto_Async(contacto);

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

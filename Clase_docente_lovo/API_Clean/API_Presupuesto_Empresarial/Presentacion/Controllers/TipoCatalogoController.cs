using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.TipoCatalogo;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class TipoCatalogoController : ControllerBase
    {
        private readonly TipoCatalogoServices _service;

        public TipoCatalogoController(TipoCatalogoServices service)
        {
            _service = service;
        }

        #region lectura_catalogo

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Cat_Tipo_Catalogo()
        {
            try
            {
                var lista = await _service.Listar_Cat_Tipo_Catalogo_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron tipos de catálogo." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_Cat_Tipo_Catalogo([FromBody] TipoCatalogoFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _service.Filtrar_Cat_Tipo_Catalogo_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron tipos de catálogo que coincidan con la búsqueda." });
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
        public async Task<IActionResult> Crear_Cat_Tipo_Catalogo([FromBody] TipoCatalogoCrearDTOs estado)
        {
            try
            {
                if (!ModelState.IsValid || estado == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _service.Crear_Cat_Tipo_Catalogo_Async(estado);

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
        public async Task<IActionResult> Actualizar_Cat_Tipo_Catalogo([FromBody] TipoCatalogoActualizarDTOs estado)
        {
            try
            {
                if (estado == null || !estado.Id_Tipo_Catalogo.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador del tipo de catálogo es obligatorio." });
                }

                DBResult resultado = await _service.Actualizar_Cat_Tipo_Catalogo_Async(estado);

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
        public async Task<IActionResult> Eliminar_Cat_Tipo_Catalogo([FromBody] TipoCatalogoEliminarDTOs estado)
        {
            try
            {
                if (estado == null || !estado.Id_Tipo_Catalogo.HasValue || !estado.Id_Modificador.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID del tipo de catálogo y el ID del modificador son requeridos." });
                }

                DBResult resultado = await _service.Eliminar_Cat_Tipo_Catalogo_Async(estado);

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

using System;
using System.Linq;
using System.Threading.Tasks;
using Aplicacion.DTOs.Moneda;
using Aplicacion.Services;
using Domain.VariablesSalida;
using Microsoft.AspNetCore.Mvc;

namespace Presentacion.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MonedaController : ControllerBase
    {
        private readonly MonedaServices _service;

        public MonedaController(MonedaServices service)
        {
            _service = service;
        }

        #region lectura_catalogo

        [HttpGet("listar")]
        public async Task<IActionResult> Listar_Cat_Monedas()
        {
            try
            {
                var lista = await _service.Listar_Cat_Monedas_Async();
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron monedas." });
                }
                return Ok(new { codigo = 200, msj = "Consulta exitosa", data = lista });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { codigo = 500, msj = ex.Message });
            }
        }

        [HttpPost("filtrar")]
        public async Task<IActionResult> Filtrar_Cat_Monedas([FromBody] MonedaFiltrarDTOs filtro)
        {
            try
            {
                if (filtro == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Los criterios de búsqueda son requeridos." });
                }
                var lista = await _service.Filtrar_Cat_Monedas_Async(filtro);
                if (lista == null || !lista.Any())
                {
                    return NotFound(new { codigo = 404, msj = "No se encontraron monedas que coincidan con la búsqueda." });
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
        public async Task<IActionResult> Crear_Cat_Monedas([FromBody] MonedaCrearDTOs moneda)
        {
            try
            {
                if (!ModelState.IsValid || moneda == null)
                {
                    return BadRequest(new { codigo = 400, msj = "Datos enviados no válidos." });
                }

                DBResult resultado = await _service.Crear_Cat_Monedas_Async(moneda);

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
        public async Task<IActionResult> Actualizar_Cat_Monedas([FromBody] MonedaActualizarDTOs moneda)
        {
            try
            {
                if (moneda == null || !moneda.Id_Moneda.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El identificador de la moneda es obligatorio." });
                }

                DBResult resultado = await _service.Actualizar_Cat_Monedas_Async(moneda);

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
        public async Task<IActionResult> Eliminar_Cat_Monedas([FromBody] MonedaEliminarDTOs moneda)
        {
            try
            {
                if (moneda == null || !moneda.Id_Moneda.HasValue)
                {
                    return BadRequest(new { codigo = 400, msj = "El ID de la moneda es requerido." });
                }

                DBResult resultado = await _service.Eliminar_Cat_Monedas_Async(moneda);

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

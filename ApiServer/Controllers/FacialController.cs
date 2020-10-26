using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using ApiServer.Service;
using Microsoft.AspNetCore.Mvc;

namespace ApiServer.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FacialController : ControllerBase
    {
        private readonly FacialService service;

        public FacialController(FacialService service)
        {
            this.service = service;
        }
        [HttpGet]
        public ActionResult<List<FacialInformation>> Get() => service.Get();
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Merodii_Beta.Models;
using Merodii_Beta.Servicios;

namespace Merodii_Beta.Controllers
{
    public class E_CategoriaController : Controller
    {
        private readonly ContextoBD _context;

        public E_CategoriaController(ContextoBD context)
        {
            _context = context;
        }

        // GET: E_Categoria
        public async Task<IActionResult> Index()
        {
            return View(await _context.Categoria.ToListAsync());
        }

        // GET: E_Categoria/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var e_Categoria = await _context.Categoria
                .FirstOrDefaultAsync(m => m.IdCategoria == id);
            if (e_Categoria == null)
            {
                return NotFound();
            }

            return View(e_Categoria);
        }

        // GET: E_Categoria/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: E_Categoria/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("IdCategoria,NombreCategoria,DescripcionCategoria,Estado")] E_Categoria e_Categoria)
        {
            if (ModelState.IsValid)
            {
                _context.Add(e_Categoria);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(e_Categoria);
        }

        // GET: E_Categoria/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var e_Categoria = await _context.Categoria.FindAsync(id);
            if (e_Categoria == null)
            {
                return NotFound();
            }
            return View(e_Categoria);
        }

        // POST: E_Categoria/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("IdCategoria,NombreCategoria,DescripcionCategoria,Estado")] E_Categoria e_Categoria)
        {
            if (id != e_Categoria.IdCategoria)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(e_Categoria);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!E_CategoriaExists(e_Categoria.IdCategoria))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            return View(e_Categoria);
        }

        // GET: E_Categoria/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var e_Categoria = await _context.Categoria
                .FirstOrDefaultAsync(m => m.IdCategoria == id);
            if (e_Categoria == null)
            {
                return NotFound();
            }

            return View(e_Categoria);
        }

        // POST: E_Categoria/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var e_Categoria = await _context.Categoria.FindAsync(id);
            if (e_Categoria != null)
            {
                _context.Categoria.Remove(e_Categoria);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool E_CategoriaExists(int id)
        {
            return _context.Categoria.Any(e => e.IdCategoria == id);
        }
    }
}

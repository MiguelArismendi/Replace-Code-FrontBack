using System;
using System.Collections.Generic;
using System.IO;
using System.Linq.Expressions;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
using System.Linq;




namespace Replace_Code_FrontBack
{
    internal class Program
    {
        static void Main(string[] args)
        {
            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string CarpetaArchivos = Path.Combine(RutaProyecto, "Archivos");
            string RutasArchivosJson = Path.Combine(CarpetaArchivos, "RutasArchivos.json");


            if (!Directory.Exists(CarpetaArchivos))
            {
                Console.WriteLine($"La carpeta no existe: {CarpetaArchivos}");
                return;
            }


            if (!File.Exists(RutasArchivosJson))
            {
                Console.WriteLine($"El archivo RutasArchivos.json no existe en: {RutasArchivosJson}");
                return;
            }

            // Leer y deserializar el archivo JSON
            var ContenidoJson = File.ReadAllText(RutasArchivosJson);
            var SerializadorArchivos = new JavaScriptSerializer();
            RutasArchivos RutasElegidas = SerializadorArchivos.Deserialize<RutasArchivos>(ContenidoJson);

            if (RutasElegidas == null || string.IsNullOrEmpty(RutasElegidas.Origen))
            {
                Console.WriteLine("El archivo rutas.json está vacío o mal formateado.");
                throw new InvalidOperationException("El archivo rutas.json está vacío o mal formateado.");
            }

            string CarpetaOrigen = RutasElegidas.Origen;
            string CarpetaDestinoNuevo = RutasElegidas.DestinoArchivoNuevo;
            string CarpetaDestinoAntiguo = RutasElegidas.DestinoArchivoAntiguo;

            // Verificar si la carpeta de origen existe
            if (!Directory.Exists(CarpetaOrigen))
            {
                Console.WriteLine($"La carpeta de origen no existe: {CarpetaOrigen}");
                return;
            }

            if (!Directory.Exists(CarpetaDestinoNuevo))
            {
                Console.WriteLine($"La carpeta del destino para el archivo nuevo no existe: {CarpetaDestinoNuevo}");
                return;
            }

            if (!Directory.Exists(CarpetaDestinoAntiguo))
            {
                Console.WriteLine($"La carpeta del destino para el archivo antiguo no existe: {CarpetaDestinoAntiguo}");
                return;
            }


                       

            // Obtener las carpetas principales donde buscar
            List<string> CarpetasABuscar = new List<string>();
            if (RutasElegidas.CarpetasPrincipales != null && RutasElegidas.CarpetasPrincipales.Count > 0)
            {
                foreach (var carpeta in RutasElegidas.CarpetasPrincipales)
                {
                    string RutaCarpeta = Path.Combine(CarpetaOrigen, carpeta);
                    if (Directory.Exists(RutaCarpeta))
                    {
                        CarpetasABuscar.Add(RutaCarpeta);
                    }
                    else
                    {
                        Console.WriteLine($"La carpeta {RutaCarpeta} no existe.");
                    }
                }
            }
            else
            {
                CarpetasABuscar.AddRange(Directory.GetDirectories(CarpetaOrigen, "*", SearchOption.TopDirectoryOnly));

            }

            if (CarpetasABuscar.Count == 0)
            {
                Console.WriteLine("No se encontraron carpetas principales para buscar.");
                return;
            }

            // Buscar solo en la subcarpeta "historia" dentro de las carpetas principales
            List<string> ListaTodosLosArchivos = new List<string>();
            string SubcarpetaEspecifica = RutasElegidas.SubcarpetaEspecifica;
            SearchOption searchOption = RutasElegidas.IncluirSubcarpetas ? SearchOption.AllDirectories : SearchOption.TopDirectoryOnly;

            foreach (var CarpetaPrincipal in CarpetasABuscar)
            {
                // Si no se especifica una subcarpeta, buscar en todas las subcarpetas de la carpeta principal
                if (string.IsNullOrEmpty(SubcarpetaEspecifica))
                {
                    var ArchivosEnCarpeta = Directory.GetFiles(CarpetaPrincipal, "*.*", SearchOption.AllDirectories);
                    ListaTodosLosArchivos.AddRange(ArchivosEnCarpeta);
                }
                else
                {
                    // Si se especifica una subcarpeta, buscar solo en esa subcarpeta
                    string RutaSubcarpeta = Path.Combine(CarpetaPrincipal, SubcarpetaEspecifica);

                    if (!Directory.Exists(RutaSubcarpeta))
                    {
                        Console.WriteLine($"La subcarpeta {RutaSubcarpeta} no existe.");
                        continue;
                    }

                    var ArchivosEnSubcarpeta = Directory.GetFiles(RutaSubcarpeta, "*.*", searchOption);
                    ListaTodosLosArchivos.AddRange(ArchivosEnSubcarpeta);
                }
            }

            string[] TodosLosArchivos = ListaTodosLosArchivos.ToArray();

            if (TodosLosArchivos.Length == 0)
            {
                Console.WriteLine("No se encontraron archivos en las subcarpetas 'HistoriaClinica' de las carpetas especificadas.");
                return;
            }




            //string[] TodosLosArchivos = Directory.GetFiles(CarpetaOrigen, "*.*", SearchOption.AllDirectories); // SearchOption.TopDirectoryOnly

            string[] Archivos; //= Directory.GetFiles(CarpetaArchivos, "*.*", SearchOption.TopDirectoryOnly);

            if (RutasElegidas.Filtro != null && !string.IsNullOrEmpty(RutasElegidas.Filtro.Tipo) && RutasElegidas.Filtro.Valores != null)
            {
                switch (RutasElegidas.Filtro.Tipo.ToLower())
                {
                    case "extension":
                        Archivos = TodosLosArchivos
                            .Where(archivo => RutasElegidas.Filtro.Valores
                                .Contains(Path.GetExtension(archivo).ToLower()))
                            .ToArray();
                        break;

                    case "nombre":
                        Archivos = TodosLosArchivos
                            .Where(archivo => RutasElegidas.Filtro.Valores
                                .Contains(Path.GetFileName(archivo)) ||
                                RutasElegidas.Filtro.Valores.Contains(Path.GetFileNameWithoutExtension(archivo)))
                            .ToArray();
                        break;

                    case "todos":
                        Archivos = TodosLosArchivos;
                        break;

                    default:
                        Console.WriteLine($"Tipo de filtro no soportado: {RutasElegidas.Filtro.Tipo}. Usando todos los archivos.");
                        Archivos = TodosLosArchivos;
                        break;
                }
            }
            else
            {
                // Si no hay filtro, procesar todos los archivos
                Archivos = TodosLosArchivos;
            }

            // Aplicar el filtro de exclusión (Excluir)
            if (RutasElegidas.Excluir != null && RutasElegidas.Excluir.Count > 0)
            {
                Archivos = Archivos
                    .Where(archivo => !RutasElegidas.Excluir
                        .Any(exclusion => Path.GetFileName(archivo).ToLower().Contains(exclusion.ToLower())))
                    .ToArray();
            }

            if (Archivos.Length == 0)
            {
                Console.WriteLine("No se encontraron archivos que cumplan con el filtro especificado.");
                return;
            }


            DateTime FechaHoraActual = DateTime.Now;

            // Formato personalizado
            string UsuarioSistema = Environment.UserName;
            string FechaFormateada = FechaHoraActual.ToString("dd-MM-yyyy_HH-mm-ss");


            foreach (string Archivo in Archivos)
            {
                string Extension = Path.GetExtension(Archivo).ToLower();
                string ContenidoOriginal = File.ReadAllText(Archivo);
                string ContenidoModificado = ContenidoOriginal;
                DirectoryInfo ContadorArchivosDestino = new DirectoryInfo(CarpetaDestinoAntiguo);

                // Obtener ruta relativa del archivo respecto a la carpeta de origen
                Uri RutaOrigenUri = new Uri(CarpetaOrigen.EndsWith(Path.DirectorySeparatorChar.ToString())
                            ? CarpetaOrigen
                            : CarpetaOrigen + Path.DirectorySeparatorChar);
                Uri ArchivoUri = new Uri(Archivo);
                string RutaRelativa = Uri.UnescapeDataString(RutaOrigenUri.MakeRelativeUri(ArchivoUri).ToString())
                                            .Replace('/', Path.DirectorySeparatorChar);

                               
                string[] PartesRutaCompleta = RutaRelativa.Split(new[] { '\\' }, StringSplitOptions.RemoveEmptyEntries);

                
                //string NombreSubdominio = PartesRutaCompleta[0];
                string NombreDelFormulario = PartesRutaCompleta[PartesRutaCompleta.Length - 1];

                string PrefijoSubcarpetas = "";
                if (PartesRutaCompleta.Length > 1)
                {
                    // Si hay subcarpetas, tomar todas las partes menos la última (el archivo)
                    string[] subcarpetas = new ArraySegment<string>(PartesRutaCompleta, 0, PartesRutaCompleta.Length - 1).ToArray();
                    PrefijoSubcarpetas = string.Join("_", subcarpetas); // "historia" o "historia_general"
                }

                int CantidadArchivosDestino = ContadorArchivosDestino.GetFiles().Length;
                //string NombreArchivoAntiguo = RutaRelativa.Replace(".biofile.com.co", "").Replace(Path.DirectorySeparatorChar, '_');
                string ArchivoViejo = Path.Combine(CarpetaDestinoAntiguo,
                          $"{PrefijoSubcarpetas.Replace(".biofile.com.co", "")}-{UsuarioSistema}-{CantidadArchivosDestino}-{NombreDelFormulario}");
                //string ArchivoViejo = Path.Combine(CarpetaDestinoAntiguo,
                //          $"{UsuarioSistema.Replace(" ", "_")}_{FechaFormateada}_{NombreArchivoAntiguo}");

                //string NombreArchivo = Path.GetFileNameWithoutExtension(Archivo);
                //string ArchivoViejo = Path.Combine(CarpetaDestinoAntiguo,
                //                      $"{UsuarioSistema.Replace(" ", "_")}_{FechaFormateada}_{NombreArchivo}{Extension}");




                //UsuarioSistema.Replace(" ","_") + "_" + FechaFormateada + "_" + Path.GetFileNameWithoutExtension(Archivo) + Extension);
                string CarpetaDestinoArchivo = Path.Combine(CarpetaDestinoNuevo, Path.GetDirectoryName(RutaRelativa));

                string ArchivoNuevo = Path.Combine(CarpetaDestinoArchivo, Path.GetFileName(Archivo));


                if (Extension == ".aspx" || Extension == ".vb")
                {
                    // Modificaciones para archivos .aspx
                    ContenidoModificado = ProcesarFormularios(ContenidoModificado);
                }
                //else if (Extension == ".vb")
                //{
                //    // Modificaciones para archivos .vb
                //    ContenidoModificado = ProcesarFormularioVb(ContenidoModificado);
                //}
                else
                {
                    Console.WriteLine($"Extensión no soportada: {Archivo}");
                    continue;
                }

                if (ContenidoOriginal != ContenidoModificado)
                {

                    // Crear archivo antiguo
                    File.WriteAllText(ArchivoViejo, ContenidoOriginal);

                    // Sobrescribir archivo con los cambios
                    File.WriteAllText(ArchivoNuevo, ContenidoModificado);

                    Console.WriteLine($"Procesado: {Archivo} -> Nuevo: {ArchivoNuevo}, Antiguo: {ArchivoViejo}");

                }
               
            }
        }


        static string ProcesarFormularios(string ContenidoFormulario)
        {

            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string RutaArchivoExpresiones = Path.Combine(RutaProyecto, "Archivos/ExpresionesRegulares.json");

            if (!File.Exists(RutaArchivoExpresiones)) // Cambiar Directory.Exists a File.Exists
            {
                Console.WriteLine($"El archivo no existe: {RutaArchivoExpresiones}");
                throw new InvalidOperationException($"El archivo no existe: {RutaArchivoExpresiones}");
            }

            List<JsonExpresionRegular> ExpresionesRegulares;

            var ContenidoJson = File.ReadAllText(RutaArchivoExpresiones); // Cambiar contenidoJson a ContenidoJson

            var Serializador = new JavaScriptSerializer();

            // Deserializar el JSON a un diccionario
            ExpresionesRegulares = Serializador.Deserialize<List<JsonExpresionRegular>>(ContenidoJson);


            if (ExpresionesRegulares == null)
            {
                throw new InvalidOperationException("Debes cargar las expresiones regulares antes de procesar.");
            }

            foreach (var PatronExpresionRegular in ExpresionesRegulares)
            {                
                var OpcionesExpresion = PatronExpresionRegular.ObtenerOpcionesRegex();

                switch (PatronExpresionRegular.MetodoUsar)
                {
                    case "ReemplazarCodigo":
                        ContenidoFormulario = ReemplazarCodigo(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, PatronExpresionRegular.NuevaLineaReemplazar, OpcionesExpresion, PatronExpresionRegular.IncluirLineaOriginal);
                        break;
                    case "ComentarCodigoJavascript":
                        ContenidoFormulario = ComentarCodigoJavascript(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular);
                        break;
                    case "ComentarCodigoHTML":
                        ContenidoFormulario = ComentarCodigoHTML(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular);
                        break;
                    case "ComentarCodigoVisualBasic":
                        ContenidoFormulario = ComentarCodigoVisualBasic(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, OpcionesExpresion);
                        break;
                    case "ReemplazarCodigoBloques":
                        ContenidoFormulario = ReemplazarCodigoBloques(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, PatronExpresionRegular.NuevaLineaReemplazar, OpcionesExpresion, PatronExpresionRegular.IncluirLineaOriginal, PatronExpresionRegular.NuevaLineaAnterior);
                        break;
                    case "ComentarCodigoJavascriptBloques":
                        ContenidoFormulario = ComentarCodigoJavascriptBloques(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, OpcionesExpresion);
                        break;
                    default:
                        throw new InvalidOperationException($"Método no reconocido: {PatronExpresionRegular.MetodoUsar}");
                }
                
            }          

            return ContenidoFormulario;
        }

        static string ComentarCodigoJavascript(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {
            //Se busca en el archivo el bloque de código que limpia las variables que llenan los diagnósticos y se comentan            
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, Coincidencia => {

                if (ContenidoFormulario.Contains($"/*\n{Coincidencia.Value}\n*/"))
                {
                    return Coincidencia.Value;
                }

                return $"/*\n{Coincidencia.Value}\n*/"; 
            
            }, OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ComentarCodigoJavascriptBloques(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            {
                string Apertura = m.Groups[1].Value;  // `if` y apertura de la llave
                string Cuerpo = m.Groups[2].Value;    // Cuerpo del if
                string Cierre = m.Groups[3].Value;    // Cierre de la llave


                if (ContenidoFormulario.Contains($"//{Apertura}"))
                {
                    return m.Value;
                }

                // Comentar todo el contenido del bloque
                return $"//{Apertura}\n    //{Cuerpo.Replace("\n", "\n    //")}\n //{Cierre}";
            });

            return ContenidoFormulario;
        }

        static string ComentarCodigoHTML(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {
            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, Coincidencia => {

                if (ContenidoFormulario.Contains($"<!-- {Coincidencia.Value} -->"))
                {
                    return Coincidencia.Value;
                }

                return $"<!-- {Coincidencia.Value} -->";
            
            }, OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ComentarCodigoVisualBasic(string ContenidoFormulario, string PatronExpresionRegular, RegexOptions OpcionesExpresion = RegexOptions.None)
        {

            string patronModificado = $"^(?!\\s*').*?({PatronExpresionRegular})";

            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, Coincidencia =>
            {
                if (ContenidoFormulario.Contains($"'{Coincidencia.Value}"))
                {
                    return Coincidencia.Value;
                }

                return $" '{Coincidencia.Value.Replace("\r\n", "\r\n' ")} ";
            }, OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ReemplazarCodigo(string ContenidoFormulario, string PatronExpresionRegular, string NuevoContenido, RegexOptions OpcionesExpresion = RegexOptions.None, bool IncluirLineaOriginal = false)
        {

            if (ContenidoFormulario.Contains(NuevoContenido))
            {
                return ContenidoFormulario;
            }

            ContenidoFormulario = Regex.Replace(
                ContenidoFormulario,
                PatronExpresionRegular,
                m => $"{NuevoContenido}{(IncluirLineaOriginal ? $"\n{m.Value}" : "")}",
                OpcionesExpresion);

            return ContenidoFormulario;
        }

        static string ReemplazarCodigoBloques(string ContenidoFormulario, string PatronExpresionRegular, string NuevoContenido, RegexOptions OpcionesExpresion = RegexOptions.None, bool IncluirLineaOriginal = false,string NuevaLineaAnterior = "")
        {

            if (ContenidoFormulario.Contains(NuevoContenido))
            {
                return ContenidoFormulario;
            }

            ContenidoFormulario = Regex.Replace(ContenidoFormulario, PatronExpresionRegular, m =>
            {
                // Capturamos la apertura y el cierre del if
                string Apertura = m.Groups[1].Value;  // Mantiene el `if` y su apertura
                string Cierre = m.Groups[3].Value;    // Mantiene el cierre del bloque `if`                

                // Concatenamos el bloque con el nuevo contenido
                return (NuevaLineaAnterior != "" && NuevaLineaAnterior != null ? NuevaLineaAnterior + "\n" : "") + Apertura + "\n" + NuevoContenido + Cierre;
            });

            return ContenidoFormulario;
        }

        [Obsolete("This metodh is obsolete, use ProcesarFormularios instead")]
        static string ProcesarFormularioVb(string ContenidoFormulario)
        {
            string RutaProyecto = AppDomain.CurrentDomain.BaseDirectory;
            string RutaArchivoExpresiones = Path.Combine(RutaProyecto, "Archivos/ExpresionesRegularesBackend.json");

            if (!File.Exists(RutaArchivoExpresiones)) // Cambiar Directory.Exists a File.Exists
            {
                Console.WriteLine($"El archivo no existe: {RutaArchivoExpresiones}");
                throw new InvalidOperationException($"El archivo no existe: {RutaArchivoExpresiones}");
            }

            List<JsonExpresionRegular> ExpresionesRegulares;

            var ContenidoJson = File.ReadAllText(RutaArchivoExpresiones); // Cambiar contenidoJson a ContenidoJson

            var Serializador = new JavaScriptSerializer();

            // Deserializar el JSON a un diccionario
            ExpresionesRegulares = Serializador.Deserialize<List<JsonExpresionRegular>>(ContenidoJson);

            if (ExpresionesRegulares == null)
            {
                throw new InvalidOperationException("Debes cargar las expresiones regulares antes de procesar.");
            }

            foreach (var PatronExpresionRegular in ExpresionesRegulares)
            {
                if (string.IsNullOrEmpty(PatronExpresionRegular.NuevaLineaReemplazar))
                {
                    var OpcionesExpresion = PatronExpresionRegular.ObtenerOpcionesRegex();
                    ContenidoFormulario = ComentarCodigoVisualBasic(ContenidoFormulario, PatronExpresionRegular.PatronExpresionRegular, OpcionesExpresion);
                }
            }

            return ContenidoFormulario;
        }

        public class JsonExpresionRegular
        {
            public string Nombre { get; set; }
            public string PatronExpresionRegular { get; set; }
            public string NuevaLineaReemplazar { get; set; }
            public string MetodoUsar { get; set; }
            public bool IncluirLineaOriginal { get; set; }
            public string OpcionesExpresion { get; set; }
            public string NuevaLineaAnterior { get; set; }

            public RegexOptions ObtenerOpcionesRegex()
            {
                if (string.IsNullOrEmpty(OpcionesExpresion)) return RegexOptions.None;

                var OpcionSinEspacios = OpcionesExpresion.Trim().ToLower();

                switch (OpcionSinEspacios)
                {
                    case "ignorecase":
                        return RegexOptions.IgnoreCase;
                    case "multiline":
                        return RegexOptions.Multiline;
                    case "singleline":
                        return RegexOptions.Singleline;
                    case "explicitcapture":
                        return RegexOptions.ExplicitCapture;
                    case "compiled":
                        return RegexOptions.Compiled;
                    case "righttoleft":
                        return RegexOptions.RightToLeft;
                    case "cultureinvariant":
                        return RegexOptions.CultureInvariant;
                    case "ecmascript":
                        return RegexOptions.ECMAScript;
                    default:
                        throw new InvalidOperationException($"Opción de expresión regular no reconocida: {OpcionesExpresion}");
                }
            }
        }

        public class RutasArchivos
        {
            public string Origen { get; set; }
            public string DestinoArchivoNuevo { get; set; }
            public string DestinoArchivoAntiguo { get; set; }
            public Filtro Filtro { get; set; } // Opcional
            public List<string> Excluir { get; set; }
            public List<string> CarpetasPrincipales { get; set; } // Nuevo campo
            public string SubcarpetaEspecifica { get; set; } // Nuevo campo
            public bool IncluirSubcarpetas { get; set; } // Nuevo campo
        }

        public class Filtro
        {
            public string Tipo { get; set; }
            public List<string> Valores { get; set; }
        }
    }
}

## Repositorio Grupo 8 - Ingenieria de Software - UTN - FRC

### Estructura de Repositorio

```
isw_2022_grupo_8_4k4
│
├─── trabajos_practicos
│       ├─── evaluable
│       │       └─── tp_<xx>
│       │
│       ├─── no_evaluable
│       │       └─── tp_<xx>
│       │
│       └─── resolucion_ejercicios
│
├─── material_de_catedra
│       ├─── teorico
│       └─── practico
│
└─── bibliografia

```

### Listado de Ítems de Configuración

| Nombre del IC                                  | Regla de Nombrado                            | Ubicacion                                   |  
|------------------------------------------------|----------------------------------------------|---------------------------------------------|
| Trabajo Práctico Evaluable                     | `tp_evaluable_<XX>.docx`                     | `/trabajos_practicos/evaluable/tp_<xx>`     |  
| Trabajo Práctico Evaluable Entregado           | `tp_evaluable_<XX>_entregado.pdf`            | `/trabajos_practicos/evaluable/tp_<xx>`     | 
| Trabajo Práctico Evaluable Corregido           | `tp_evaluable_<XX>_corregido.pdf`            | `/trabajos_practicos/evaluable/tp_<xx>`     | 
| Artefacto de Código                            | `<nombre_archivo>.<extension>`               | `/trabajos_practicos/evaluable/tp_<xx>`     |
| Trabajo Práctico No Evaluable                  | `tp_no_evaluable_<XX>.docx`                  | `/trabajos_practicos/no_evaluable/tp_<xx>`  |
| Resolución de Ejercicios de Trabajos Practicos | `resolucion_ejercicio_<XX>.docx`             | `/trabajos_practicos/resolucion_ejercicios` |
| Presentaciones de Clase                        | `presentacion_teorico_<XX>_<titulo>.pdf`     | `/material_de_catedra/teorico`              |
| Guia De Trabajos Prácticos                     | `guia_trabajos_practicos_<XX>.pdf`           | `/material_de_catedra/practico`             |
| Guia De Trabajos Prácticos Resueltos           | `guia_trabajos_practicos_resueltos_<XX>.pdf` | `/material_de_catedra/practico`             |
| Material Bibliográfico                         | `material_bibliografico_<titulo>.pdf`        | `/bibliografi`                              |

| Sigla      | Significado                                 |
|------------|---------------------------------------------|
| `<XX>`     | Número cardinal comenzando en 01            |
| `<titulo>` | Cadena de caracteres en estilo `snake_case` |


### Definición De Generación de Linea Base

Se generará una linea base cada vez que se obtenga una calificacion de un trabajo práctico evaluable.

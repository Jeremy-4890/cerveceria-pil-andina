// static/js/charts.js
// Gráficos adicionales para el dashboard

// Función para cargar producción por planta
function cargarProduccionPorPlanta() {
    fetch('/api/produccion_planta')
        .then(response => response.json())
        .then(data => {
            const ctx = document.getElementById('produccionPlantaChart');
            if (ctx) {
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: data.plantas,
                        datasets: [{
                            label: 'Unidades Producidas (mes actual)',
                            data: data.cantidades,
                            backgroundColor: '#2E7D32',
                            borderColor: '#1B5E20',
                            borderWidth: 1
                        }]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Unidades'
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                position: 'top',
                            }
                        }
                    }
                });
            }
        });
}

// Función para cargar top distribuidores
function cargarTopDistribuidores() {
    fetch('/api/top_distribuidores')
        .then(response => response.json())
        .then(data => {
            const ctx = document.getElementById('topDistribuidoresChart');
            if (ctx) {
                new Chart(ctx, {
                    type: 'doughnut',
                    data: {
                        labels: data.nombres,
                        datasets: [{
                            data: data.compras,
                            backgroundColor: ['#2E7D32', '#388E3C', '#43A047', '#4CAF50', '#66BB6A'],
                            borderWidth: 0
                        }]
                    },
                    options: {
                        responsive: true,
                        plugins: {
                            legend: {
                                position: 'bottom',
                            },
                            tooltip: {
                                callbacks: {
                                    label: function(context) {
                                        const label = context.label || '';
                                        const value = context.raw || 0;
                                        const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                        const percentage = ((value / total) * 100).toFixed(1);
                                        return `${label}: Bs ${value.toLocaleString()} (${percentage}%)`;
                                    }
                                }
                            }
                        }
                    }
                });
            }
        });
}

// Función para cargar rotación de inventario
function cargarRotacionInventario() {
    fetch('/api/rotacion_inventario')
        .then(response => response.json())
        .then(data => {
            const ctx = document.getElementById('rotacionInventarioChart');
            if (ctx) {
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.productos,
                        datasets: [
                            {
                                label: 'Mes Actual',
                                data: data.salidas_mes_actual,
                                borderColor: '#2E7D32',
                                backgroundColor: 'rgba(46, 125, 50, 0.1)',
                                fill: true,
                                tension: 0.4
                            },
                            {
                                label: 'Mes Anterior',
                                data: data.salidas_mes_anterior,
                                borderColor: '#FFC107',
                                backgroundColor: 'rgba(255, 193, 7, 0.1)',
                                fill: true,
                                tension: 0.4
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        scales: {
                            y: {
                                beginAtZero: true,
                                title: {
                                    display: true,
                                    text: 'Unidades Vendidas'
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                position: 'top',
                            }
                        }
                    }
                });
            }
        });
}

// Inicializar todos los gráficos cuando el DOM esté listo
document.addEventListener('DOMContentLoaded', function() {
    cargarProduccionPorPlanta();
    cargarTopDistribuidores();
    cargarRotacionInventario();
});
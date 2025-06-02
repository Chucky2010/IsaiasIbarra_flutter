import 'package:flutter/material.dart';
import 'package:mi_proyecto/components/custom_bottom_navigation_bar.dart';
import 'package:mi_proyecto/components/side_menu.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos los colores del tema actual
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de SODEP'),
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo y nombre de la empresa
              _buildCompanyHeader(context),
              
              const SizedBox(height: 24),
              
              // Sección "Sobre la Empresa"
              _buildSectionWithIcon(
                context: context,
                icon: Icons.info_outline,
                title: 'Sobre la Empresa',
                content: 'SODEP S.A. es una empresa comprometida con la '
                    'excelencia y el desarrollo profesional, brindando '
                    'soluciones innovadoras y servicios de calidad a '
                    'nuestros clientes.',
              ),
              
              const SizedBox(height: 24),
              
              // Sección "Valores Sodepianos"
              _buildSectionHeader(context, Icons.favorite, 'Valores Sodepianos'),
              
              const SizedBox(height: 16),
              
              // Tarjetas de valores
              _buildValueCard(
                context: context,
                icon: Icons.shield_outlined,
                title: 'Honestidad',
                description: 'Actuamos con transparencia y verdad en todas nuestras relaciones',
              ),
              
              const SizedBox(height: 8),
              
              _buildValueCard(
                context: context,
                icon: Icons.star_outline,
                title: 'Calidad',
                description: 'Nos esforzamos por la excelencia en cada proyecto y servicio',
              ),
              
              const SizedBox(height: 8),
              
              _buildValueCard(
                context: context,
                icon: Icons.sync_alt,
                title: 'Flexibilidad',
                description: 'Nos adaptamos a las necesidades cambiantes del mercado',
                isSecondary: true,
              ),
              
              const SizedBox(height: 8),
              
              _buildValueCard(
                context: context,
                icon: Icons.chat_outlined,
                title: 'Comunicación',
                description: 'Mantenemos diálogo abierto y efectivo con todos nuestros stakeholders',
              ),
              
              const SizedBox(height: 8),
              
              _buildValueCard(
                context: context,
                icon: Icons.animation,
                title: 'Autogestión',
                description: 'Fomentamos la responsabilidad personal y la iniciativa propia',
              ),
              
              const SizedBox(height: 24),
              
              // Información de Contacto
              _buildSectionWithIcon(
                context: context,
                icon: Icons.contact_page_outlined,
                title: 'Información de Contacto',
                content: '',
              ),
              
              const SizedBox(height: 16),
              
              // Dirección
              _buildContactItem(
                context: context,
                icon: Icons.location_on_outlined,
                title: 'Dirección',
                details: 'Bélgica 839 c/ Eusebio Lillo\nAsunción, Paraguay',
              ),
              
              const SizedBox(height: 16),
              
              // Teléfono
              _buildContactItem(
                context: context,
                icon: Icons.phone_outlined,
                title: 'Teléfono',
                details: '(+595) 981-131-694',
              ),
              
              const SizedBox(height: 16),
              
              // Email
              _buildContactItem(
                context: context,
                icon: Icons.email_outlined,
                title: 'Email',
                details: 'info@sodep.com.py',
              ),
              
              const SizedBox(height: 16),
              
              // Sitio Web
              _buildContactItem(
                context: context,
                icon: Icons.language_outlined,
                title: 'Sitio Web',
                details: 'www.sodep.com.py',
              ),
              
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        selectedIndex: 0, // Usar 0 como valor por defecto, que corresponde al primer ítem
      ),
    );
  }

  // Widget para el encabezado con logo y nombre de la empresa
  Widget _buildCompanyHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SODEP',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Software & Equipamiento & Productos',
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'SODEP S.A.',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Soluciones de Desarrollo Profesional',
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
  
  // Widget para construir un encabezado de sección
  Widget _buildSectionHeader(BuildContext context, IconData icon, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  // Widget para construir una sección con icono
  Widget _buildSectionWithIcon({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, icon, title),
        if (content.isNotEmpty) const SizedBox(height: 8),
        if (content.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
          ),
      ],
    );
  }

  // Widget para construir una tarjeta de valor
  Widget _buildValueCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    bool isSecondary = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSecondary ? colorScheme.tertiary : colorScheme.primary;
    
    return Card(
      margin: EdgeInsets.zero,
      color: color,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: colorScheme.onPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para elementos de contacto
  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String details,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              details,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

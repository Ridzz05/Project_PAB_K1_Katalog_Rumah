import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color inActiveIconColor = Color.fromARGB(255, 138, 142, 138);

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Theme(
              data: Theme.of(context).copyWith(
                navigationBarTheme: NavigationBarThemeData(
                  labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF7643),
                        );
                      }
                      return const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: inActiveIconColor,
                      );
                    },
                  ),
                ),
              ),
              child: NavigationBar(
                selectedIndex: currentIndex,
                onDestinationSelected: onTap,
                height: 72,
                elevation: 0,
                backgroundColor: Colors.white,
                indicatorColor: const Color(0x1AFF7643),
                animationDuration: const Duration(milliseconds: 350),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  NavigationDestination(
                    icon: SvgPicture.string(
                      homeIcon,
                      colorFilter: const ColorFilter.mode(
                        inActiveIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    selectedIcon: _AnimatedActiveIcon(
                      child: SvgPicture.string(
                        homeIcon,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF7643),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: 'Beranda',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.string(
                      searchIcon,
                      colorFilter: const ColorFilter.mode(
                        inActiveIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    selectedIcon: _AnimatedActiveIcon(
                      child: SvgPicture.string(
                        searchIcon,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF7643),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: 'Cari',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.string(
                      favoriteIcon,
                      colorFilter: const ColorFilter.mode(
                        inActiveIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    selectedIcon: _AnimatedActiveIcon(
                      child: SvgPicture.string(
                        favoriteIcon,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF7643),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: 'Favorit',
                  ),
                  NavigationDestination(
                    icon: SvgPicture.string(
                      userIcon,
                      colorFilter: const ColorFilter.mode(
                        inActiveIconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    selectedIcon: _AnimatedActiveIcon(
                      child: SvgPicture.string(
                        userIcon,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF7643),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    label: 'Profil',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedActiveIcon extends StatelessWidget {
  const _AnimatedActiveIcon({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: child,
      ),
    );
  }
}

//TO DO: Mengganti Icon Dengan SVG String
//icon home
const homeIcon =
    '''<svg width="22" height="20" viewBox="0 0 22 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M2 8.5L11 1L20 8.5V18C20 18.5523 19.5523 19 19 19H14C13.4477 19 13 18.5523 13 18V13H9V18C9 18.5523 8.55228 19 8 19H3C2.44772 19 2 18.5523 2 18V8.5Z" stroke="#B6B6B6" stroke-width="1" stroke-linejoin="round"/>
</svg>''';
//icon search
const searchIcon =
    '''<svg width="22" height="20" viewBox="0 0 22 20" fill="none" xmlns="http://www.w3.org/2000/svg">
  <circle cx="9" cy="8" r="6" stroke="#B6B6B6" stroke-width="1"/>
  <path d="M13.5 12.5L20 19" stroke="#B6B6B6" stroke-width="1" stroke-linecap="round"/>
</svg>''';
//icon favorite
const favoriteIcon =
    '''<svg width="22" height="20" viewBox="0 0 22 20" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M19.1585 10.6702L11.2942 18.6186C11.1323 18.7822 10.8687 18.7822 10.7058 18.6186L2.84145 10.6702C1.81197 9.62861 1.2443 8.24408 1.2443 6.77039C1.2443 5.29671 1.81197 3.91218 2.84145 2.87063C3.90622 1.79552 5.30308 1.25744 6.70098 1.25744C8.09887 1.25744 9.49573 1.79552 10.5605 2.87063C10.8033 3.11607 11.1967 3.11607 11.4405 2.87063C13.568 0.720415 17.03 0.720415 19.1585 2.87063C20.188 3.91113 20.7557 5.29566 20.7557 6.77039C20.7557 8.24408 20.188 9.62966 19.1585 10.6702ZM20.0386 1.98013C17.5687 -0.516223 13.6313 -0.652578 11.0005 1.57316C8.36973 -0.652578 4.43342 -0.516223 1.96245 1.98013C0.696354 3.25977 0 4.96001 0 6.77039C0 8.57972 0.696354 10.281 1.96245 11.5607L9.82678 19.5091C10.1495 19.8364 10.575 20 11.0005 20C11.426 20 11.8505 19.8364 12.1743 19.5091L20.0386 11.5607C21.3036 10.2821 22 8.58077 22 6.77039C22 4.96001 21.3036 3.25872 20.0386 1.98013Z" fill="#B6B6B6"/>
</svg>''';
//icon profile
const userIcon =
    '''<svg width="22" height="22" viewBox="0 0 22 22" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M20.3955 20.1586C20.1123 20.5122 19.6701 20.723 19.2127 20.723H2.78733C2.32989 20.723 1.8877 20.5122 1.60452 20.1586C1.33768 19.8263 1.24619 19.4248 1.3453 19.0275C2.44207 14.678 6.41199 11.6395 11.0005 11.6395C15.588 11.6395 19.5579 14.678 20.6547 19.0275C20.7538 19.4248 20.6623 19.8263 20.3955 20.1586ZM6.35536 5.8203C6.35536 3.31645 8.43888 1.27802 11.0005 1.27802C13.5611 1.27802 15.6446 3.31645 15.6446 5.8203C15.6446 8.32522 13.5611 10.3615 11.0005 10.3615C8.43888 10.3615 6.35536 8.32522 6.35536 5.8203ZM21.9235 18.7219C20.939 14.8154 17.9068 11.8451 14.1035 10.7843C15.8102 9.75979 16.9516 7.91838 16.9516 5.8203C16.9516 2.61141 14.2821 0 11.0005 0C7.71787 0 5.04839 2.61141 5.04839 5.8203C5.04839 7.91838 6.18981 9.75979 7.89649 10.7843C4.09321 11.8451 1.06104 14.8154 0.0764552 18.7219C-0.118501 19.4962 0.0633855 20.3077 0.576371 20.9456C1.11223 21.6166 1.91928 22 2.78733 22H19.2127C20.0807 22 20.8878 21.6166 21.4236 20.9456C21.9366 20.3077 22.1185 19.4962 21.9235 18.7219Z" fill="#B6B6B6"/>
</svg>''';

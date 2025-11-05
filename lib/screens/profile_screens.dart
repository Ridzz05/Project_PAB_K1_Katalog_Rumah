import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.onLogout,
    this.userName,
    this.userEmail,
    this.userPassword,
  });

  final VoidCallback onLogout;
  final String? userName;
  final String? userEmail;
  final String? userPassword;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            _ProfileInfoCard(
              name: userName,
              email: userEmail,
              password: userPassword,
            ),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              iconSvg: accountIconSvg,
              press: () {},
            ),
            ProfileMenu(
              text: "Notifications",
              iconSvg: bellIconSvg,
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              iconSvg: settingsIconSvg,
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              iconSvg: helpIconSvg,
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              iconSvg: logoutIconSvg,
              press: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          const CircleAvatar(
            backgroundImage:
                NetworkImage("https://i.postimg.cc/0jqKB6mS/Profile-Image.png"),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: SvgPicture.string(cameraIcon),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    required this.text,
    required this.iconSvg,
    this.press,
    super.key,
  });

  final String text, iconSvg;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF7643),
          padding: const EdgeInsets.all(20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.string(
              iconSvg,
              colorFilter:
                  const ColorFilter.mode(Color(0xFFFF7643), BlendMode.srcIn),
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({
    required this.name,
    required this.email,
    required this.password,
  });

  final String? name;
  final String? email;
  final String? password;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Akun',
            style: TextStyle(
              color: Color(0xFF1F1F1F),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Nama', value: name ?? '-'),
          const SizedBox(height: 8),
          _InfoRow(label: 'Email', value: email ?? '-'),
          const SizedBox(height: 8),
          _InfoRow(label: 'Password', value: password ?? '-'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF757575),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1F1F1F),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

const cameraIcon =
    '''<svg width="20" height="16" viewBox="0 0 20 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 12.0152C8.49151 12.0152 7.26415 10.8137 7.26415 9.33902C7.26415 7.86342 8.49151 6.6619 10 6.6619C11.5085 6.6619 12.7358 7.86342 12.7358 9.33902C12.7358 10.8137 11.5085 12.0152 10 12.0152ZM10 5.55543C7.86698 5.55543 6.13208 7.25251 6.13208 9.33902C6.13208 11.4246 7.86698 13.1217 10 13.1217C12.133 13.1217 13.8679 11.4246 13.8679 9.33902C13.8679 7.25251 12.133 5.55543 10 5.55543ZM18.8679 13.3967C18.8679 14.2226 18.1811 14.8935 17.3368 14.8935H2.66321C1.81887 14.8935 1.13208 14.2226 1.13208 13.3967V5.42346C1.13208 4.59845 1.81887 3.92664 2.66321 3.92664H4.75C5.42453 3.92664 6.03396 3.50952 6.26604 2.88753L6.81321 1.41746C6.88113 1.23198 7.06415 1.10739 7.26604 1.10739H12.734C12.9358 1.10739 13.1189 1.23198 13.1877 1.41839L13.734 2.88845C13.966 3.50952 14.5755 3.92664 15.25 3.92664H17.3368C18.1811 3.92664 18.8679 4.59845 18.8679 5.42346V13.3967ZM17.3368 2.82016H15.25C15.0491 2.82016 14.867 2.69466 14.7972 2.50917L14.2519 1.04003C14.0217 0.418041 13.4113 0 12.734 0H7.26604C6.58868 0 5.9783 0.418041 5.74906 1.0391L5.20283 2.50825C5.13302 2.69466 4.95094 2.82016 4.75 2.82016H2.66321C1.19434 2.82016 0 3.98846 0 5.42346V13.3967C0 14.8326 1.19434 16 2.66321 16H17.3368C18.8057 16 20 14.8326 20 13.3967V5.42346C20 3.98846 18.8057 2.82016 17.3368 2.82016Z" fill="#757575"/>
</svg>''';

const accountIconSvg =
    '''<svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M12 12C14.7614 12 17 9.76142 17 7C17 4.23858 14.7614 2 12 2C9.23858 2 7 4.23858 7 7C7 9.76142 9.23858 12 12 12ZM12 14C8.13401 14 5 17.134 5 21V22H19V21C19 17.134 15.866 14 12 14Z" fill="#757575"/>
</svg>''';

const bellIconSvg =
    '''<svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M12 22C13.1046 22 14 21.1046 14 20H10C10 21.1046 10.8954 22 12 22ZM18 16V11C18 7.92893 16.0233 5.28215 13.2001 4.49254L13 4.436V4C13 3.44772 12.5523 3 12 3C11.4477 3 11 3.44772 11 4V4.436L10.7999 4.49254C7.9767 5.28215 6 7.92893 6 11V16L5 17V18H19V17L18 16Z" fill="#757575"/>
</svg>''';

const settingsIconSvg =
    '''<svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M9.243 2L8.905 4.473C8.016 4.874 7.197 5.414 6.474 6.07L4.119 5.299L2 9.021L4.011 10.681C3.925 11.108 3.879 11.55 3.879 12C3.879 12.45 3.925 12.892 4.011 13.319L2 14.979L4.119 18.701L6.474 17.93C7.197 18.586 8.016 19.126 8.905 19.527L9.243 22H14.757L15.095 19.527C15.984 19.126 16.803 18.586 17.526 17.93L19.881 18.701L22 14.979L19.989 13.319C20.075 12.892 20.121 12.45 20.121 12C20.121 11.55 20.075 11.108 19.989 10.681L22 9.021L19.881 5.299L17.526 6.07C16.803 5.414 15.984 4.874 15.095 4.473L14.757 2H9.243ZM12 15.5C10.067 15.5 8.5 13.933 8.5 12C8.5 10.067 10.067 8.5 12 8.5C13.933 8.5 15.5 10.067 15.5 12C15.5 13.933 13.933 15.5 12 15.5Z" fill="#757575"/>
</svg>''';

const helpIconSvg =
    '''<svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M12 2C6.47715 2 2 6.47715 2 12C2 17.5228 6.47715 22 12 22C17.5228 22 22 17.5228 22 12C22 6.47715 17.5228 2 12 2ZM10.75 10.5C10.75 9.80964 11.3096 9.25 12 9.25C12.6904 9.25 13.25 9.80964 13.25 10.5C13.25 11.1995 12.9265 11.4971 12.3481 11.9632C11.7053 12.4806 10.75 13.247 10.75 15H13.25C13.25 14.3183 13.5491 14.0827 14.1519 13.6035C14.7829 13.1015 15.75 12.3295 15.75 10.5C15.75 8.42893 14.0711 6.75 12 6.75C9.92893 6.75 8.25 8.42893 8.25 10.5H10.75ZM11 17H13V19H11V17Z" fill="#757575"/>
</svg>''';

const logoutIconSvg =
    '''<svg width="22" height="22" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M4 3C2.89543 3 2 3.89543 2 5V19C2 20.1046 2.89543 21 4 21H11V19H4V5H11V3H4ZM21 12L16 7L14.59 8.41L17.17 11H9V13H17.17L14.59 15.59L16 17L21 12Z" fill="#757575"/>
</svg>''';

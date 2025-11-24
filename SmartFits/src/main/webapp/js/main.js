// small helper to toggle password inputs by id
function togglePassword(id) {
    var el = document.getElementById(id);
    if (!el) return;
    if (el.type === 'password') el.type = 'text';
    else el.type = 'password';
}

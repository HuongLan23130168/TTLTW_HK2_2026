
function toggleProfileEdit() {
  const viewDiv = document.getElementById('profile-view');
  const editForm = document.getElementById('profile-edit');

  if (!viewDiv || !editForm) return;

  if (editForm.classList.contains('hidden')) {
    viewDiv.classList.add('hidden');
    editForm.classList.remove('hidden');
  } else {
    editForm.classList.add('hidden');
    viewDiv.classList.remove('hidden');
  }
}

function openAddressModal() {
  const modal = document.getElementById('modal-address');
  if (modal) modal.classList.add('show');
}

function closeAddressModal() {
  const modal = document.getElementById('modal-address');
  if (modal) modal.classList.remove('show');
}
function openEditModal(id, address, isDefault) {
  const idInput = document.getElementById('edit-id');
  const addressInput = document.getElementById('edit-address');
  const defaultInput = document.getElementById('edit-isDefault');
  const modal = document.getElementById('modal-edit-address');

  if (!idInput || !addressInput || !defaultInput || !modal) return;

  idInput.value = id;
  addressInput.value = address;
  defaultInput.checked = (isDefault == 1);

  modal.classList.add('show');
}

function closeEditModal() {
  const modal = document.getElementById('modal-edit-address');
  if (modal) modal.classList.remove('show');
}

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.edit-address-btn').forEach(function (button) {
    button.addEventListener('click', function () {
      openEditModal(button.dataset.id, button.dataset.address || '', button.dataset.default);
    });
  });
});

window.addEventListener('click', function(event) {
  const modalAdd = document.getElementById('modal-address');
  const modalEdit = document.getElementById('modal-edit-address');
  if (event.target == modalAdd) {
    closeAddressModal();
  }
  if (event.target == modalEdit) {
    closeEditModal();
  }
});

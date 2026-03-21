
function toggleProfileEdit() {
  const viewDiv = document.getElementById('profile-view');
  const editForm = document.getElementById('profile-edit');

  if (editForm.classList.contains('hidden')) {
    viewDiv.classList.add('hidden');
    editForm.classList.remove('hidden');
  } else {
    editForm.classList.add('hidden');
    viewDiv.classList.remove('hidden');
  }
}

function openAddressModal() {
  document.getElementById('modal-address').classList.add('show');
}

function closeAddressModal() {
  document.getElementById('modal-address').classList.remove('show');
}

window.onclick = function(event) {
  const modal = document.getElementById('modal-address');
  if (event.target == modal) {
    closeAddressModal();
  }
}


function toggleProfileEdit() {
  const viewDiv = document.getElementById('profile-view');
  const editForm = document.getElementById('profile-edit');

  if (editForm.classList.contains('hidden')) {
    viewDiv.classList.add('hidden');
    editForm.classList.remove('hidden');
  } else {
    editForm.classList.add('hidden');
    viewDiv.classList.remove('hidden');
  }
}

function openAddressModal() {
  document.getElementById('modal-address').classList.add('show');
}

function closeAddressModal() {
  document.getElementById('modal-address').classList.remove('show');
}

window.onclick = function(event) {
  const modal = document.getElementById('modal-address');
  if (event.target == modal) {
    closeAddressModal();
  }
}
function openEditModal(id, address, isDefault) {
  document.getElementById('edit-id').value = id;
  document.getElementById('edit-address').value = address;

  document.getElementById('edit-isDefault').checked = (isDefault == 1);

  document.getElementById('modal-edit-address').classList.add('show');
}

function closeEditModal() {
  document.getElementById('modal-edit-address').classList.remove('show');
}

window.onclick = function(event) {
  const modalAdd = document.getElementById('modal-address');
  const modalEdit = document.getElementById('modal-edit-address');

  if (event.target == modalAdd) {
    closeAddressModal();
  }
  if (event.target == modalEdit) {
    closeEditModal();
  }
}

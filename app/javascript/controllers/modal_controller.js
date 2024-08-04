import { Modal } from "tailwindcss-stimulus-components"

export default class extends Modal {
  connect() {
    super.connect();
    // this.dialogTarget.querySelector('button').focus(); 
  }
}
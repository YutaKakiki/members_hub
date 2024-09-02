import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "container", "field"];
  static values = {
    currentIndex: Number // static values を定義
  };

  connect() {
    // 初期値の設定
    if (this.currentIndexValue === undefined) {
      this.currentIndexValue = 1;
    }
  }

  clearForm() {
    this.inputTarget.value = "";
  }

  addField(e) {
    e.preventDefault();
    const fieldTemplate = this.fieldTarget.cloneNode(true);
    fieldTemplate.querySelector("input").value = "";
    // currentIndex を更新
    this.currentIndexValue += 1;
    this.iterateNameAttributes(fieldTemplate);
    fieldTemplate.querySelector(".hidden").classList.remove("hidden");
    fieldTemplate.querySelector(".margin").classList.add("hidden");
    fieldTemplate.querySelector('[data-field-id]').setAttribute("data-field-id", this.generateUUID());
    this.containerTarget.appendChild(fieldTemplate);

  }

  removeField(e) {
    e.preventDefault();
    const field = e.target.closest('[data-field-id]');
    if (field) {
      field.remove();
      this.currentIndexValue -= 1;
    }
  }

  generateUUID() {
    return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, c =>
      (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
    );
  }

  // パラメータを識別するために、name属性を変更する
  // 元のname属性はfield1、value1なので、＋１した値からイテレートする
  iterateNameAttributes(fieldTemplate) {
    const collectionSelect = fieldTemplate.querySelector("select[name^='field']");
    if (collectionSelect) {
      collectionSelect.name = `field${this.currentIndexValue+1}`;
    }

    const textField = fieldTemplate.querySelector("input[name^='value']");
    if (textField) {
      textField.name = `value${this.currentIndexValue+1}`;
    }
  }

  submit(){
    clearTimeout(this.timeout)
    this.timeout=setTimeout(()=>{
      this.element.requestSubmit()
    },200)
  }
}

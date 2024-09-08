import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="clipboard"
export default class extends Controller {
  static targets = ["source", "button"];

  copy() {
    // ↓ボタンクリック時にテキスト(this.sourceTarget.value)をクリップボードにコピーする
    navigator.clipboard.writeText(this.sourceTarget.value);
    // ↓コピー完了後にボタン（リンク）のテキストを上書きする
    this.buttonTarget.innerHTML =
      '<i class="fa-solid fa-clipboard-check"></i> コピー完了！';
  }
}

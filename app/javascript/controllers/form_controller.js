import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input"];

// inputのvalue属性を空にする
// プロフィール設定画面にて、設定アクションはは部分更新のため、フォームが置き換わらない
// そのため、「追加」でサブミット時にこのアクションを発火させる
  clearForm() {
    this.inputTarget.value = "";
  }
}

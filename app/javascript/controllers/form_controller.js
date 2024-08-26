import { Controller } from "@hotwired/stimulus";
// inputのvalue属性を空にする
// プロフィール設定画面にて、設定アクションはは部分更新のため、フォームが置き換わらない
// そのため、「追加」でサブミット時にこのアクションを発火させる
export default class extends Controller {
  static targets = ["input"];

  clearForm() {
    this.inputTarget.value = "";
  }
}

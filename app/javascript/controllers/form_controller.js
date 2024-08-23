import { Controller } from "@hotwired/stimulus";
// inputのvalue属性を空にする
// プロフィール登録画面にて、登録は部分更新のため、フォームが置き換わらない
// そのため、「追加」でサブミット時にこのアクションを発火させる
export default class extends Controller {
  static targets = ["input"];

  clearForm() {
    this.inputTarget.value = "";
  }
}

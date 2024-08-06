import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  preview() {
    let input = this.inputTarget
    let preview = this.previewTarget
    let file = input.files[0]

    if (file) {
      let reader = new FileReader()

      reader.onload = (event) => {
        let img = new Image()
        img.src = event.target.result

        img.onload = () => {
          let canvas = document.createElement('canvas')
          let ctx = canvas.getContext('2d')

          // リサイズの設定
          let maxWidth = 200 // 最大幅
          let maxHeight = 200 // 最大高さ
          let width = img.width
          let height = img.height

          // 縦横比を保ちながらリサイズ
          if (width > height) {
            if (width > maxWidth) {
              height *= maxWidth / width
              width = maxWidth
            }
          } else {
            if (height > maxHeight) {
              width *= maxHeight / height
              height = maxHeight
            }
          }

          canvas.width = width
          canvas.height = height
          ctx.drawImage(img, 0, 0, width, height)

          // リサイズした画像をプレビューとして表示
          preview.src = canvas.toDataURL('image/jpeg')
        }
      }
      reader.readAsDataURL(file)
    } else {
      preview.src = ""
    }
  }
}

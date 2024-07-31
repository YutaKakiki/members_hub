const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      keyframes: {
        flashFade: {
          "0%": { transform: "translateX(180px)", opacity: 0 },
          "20%": { transform: "translateX(0)", opacity: 1 },
          "80%": { transform: "translateX(0)", opacity: 1 },
          "100%": { transform: "translateX(180px)", opacity: 0 },
        },
      },
      animation: {
        flash: "flashFade 7.0s forwards",
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}

<script setup lang="ts">
import sectionBackgroundUrl from '../assets/section_background.png'

const style = {
  backgroundImage: `url("${sectionBackgroundUrl}")`
}
</script>

<template>
  <div class="slidev-layout section w-full h-full grid text-white bg-no-repeat bg-center bg-cover" :style="style">
    <div class="my-auto text-center font-bold">
      <slot />
    </div>
  </div>
</template>

<script setup lang="ts">
import coverUrl from '../assets/cover.png'

const style = {
  backgroundImage: `url("${coverUrl}")`
}
</script>

<template>
  <div class="slidev-layout cover text-white bg-no-repeat bg-center bg-cover" :style="style">
    <div class="my-auto w-full font-bold">
      <slot />
    </div>
  </div>
</template>

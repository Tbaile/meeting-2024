<script lang="ts" setup>
import { useQRCode } from '@vueuse/integrations/useQRCode'

const props = defineProps<{
  value: string,
  options?: QRCode.QRCodeToDataURLOptions
}>()

const qrcode = useQRCode(props.value, props.options ?? {})
</script>

<template>
    <img :src="qrcode">
</template>
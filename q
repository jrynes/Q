  .animate {
    animation-duration: 0.3s;
    animation-fill-mode: both;
  }
}

@keyframes slideIn {
  0% {
    transform: translateY(1rem);
    opacity: 0;
  }
  100% {
    transform: translateY(0rem);
    opacity: 1;
  }
}

.slideIn {
  animation-name: slideIn;
}

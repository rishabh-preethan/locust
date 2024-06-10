import { Container, Typography } from '@mui/material';

// import About from 'components/Layout/Footer/About';

export default function Footer() {
  return (
    <Container
      maxWidth='xl'
      sx={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        height: 'var(--footer-height)',
        gap: 1, // Add gap between About and Typography components
      }}
    >
      {/* <About /> */}
      <Typography
        sx={{
          color: 'grey',
          fontSize: '0.875rem', // Smaller font size
        }}
        variant='body2'
      >
        Powered by Locust
      </Typography>
    </Container>// Added by Rishabh 6/5/24
  );
}

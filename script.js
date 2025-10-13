// ========== Dark Mode Toggle ==========
const themeToggle = document.getElementById('themeToggle');
const html = document.documentElement;

// Check for saved theme preference or default to 'light'
const currentTheme = localStorage.getItem('theme') || 'light';
html.setAttribute('data-theme', currentTheme);

themeToggle?.addEventListener('click', () => {
    const theme = html.getAttribute('data-theme');
    const newTheme = theme === 'light' ? 'dark' : 'light';
    html.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    
    // Animate toggle button
    themeToggle.style.transform = 'scale(0.9) rotate(180deg)';
    setTimeout(() => {
        themeToggle.style.transform = '';
    }, 300);
});

// Mobile Menu Toggle
const mobileMenuToggle = document.getElementById('mobileMenuToggle');
const navMenu = document.getElementById('navMenu');

mobileMenuToggle.addEventListener('click', () => {
    navMenu.classList.toggle('active');
    
    // Animate hamburger menu
    const spans = mobileMenuToggle.querySelectorAll('span');
    if (navMenu.classList.contains('active')) {
        spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
        spans[1].style.opacity = '0';
        spans[2].style.transform = 'rotate(-45deg) translate(7px, -6px)';
    } else {
        spans[0].style.transform = 'none';
        spans[1].style.opacity = '1';
        spans[2].style.transform = 'none';
    }
});

// Close mobile menu when clicking on a nav link
const navLinks = document.querySelectorAll('.nav-link');
navLinks.forEach(link => {
    link.addEventListener('click', () => {
        if (navMenu.classList.contains('active')) {
            navMenu.classList.remove('active');
            const spans = mobileMenuToggle.querySelectorAll('span');
            spans[0].style.transform = 'none';
            spans[1].style.opacity = '1';
            spans[2].style.transform = 'none';
        }
    });
});

// Smooth scrolling for navigation links (fallback for browsers without CSS support)
document.addEventListener('click', (e) => {
    const link = e.target.closest('a[href^="#"]');
    if (!link) return;
    
    e.preventDefault();
    const targetId = link.getAttribute('href');
    const targetSection = document.querySelector(targetId);
    
    if (targetSection) {
        const offsetTop = targetSection.offsetTop - 70; // Account for fixed navbar
        window.scrollTo({
            top: offsetTop,
            behavior: 'smooth'
        });
    }
});

// Form submission handler
const contactForm = document.getElementById('contactForm');
contactForm.addEventListener('submit', (e) => {
    e.preventDefault();
    
    // Get form data
    const formData = {
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        message: document.getElementById('message').value
    };
    
    // In a real application, you would send this data to a server
    console.log('Form submitted:', formData);
    
    // Show success message
    alert('Thank you for your message! We will get back to you soon.');
    
    // Reset form
    contactForm.reset();
});

// Add scroll effect to navbar
let lastScroll = 0;
const navbar = document.querySelector('.navbar');

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
    
    lastScroll = currentScroll;
}, { passive: true });

// Enhanced animation on scroll
const observerOptions = {
    threshold: 0.15,
    rootMargin: '0px 0px -80px 0px'
};

const animateObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('animate');
            // Unobserve after animation to improve performance
            animateObserver.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe feature cards
document.addEventListener('DOMContentLoaded', () => {
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        animateObserver.observe(card);
    });

    // Safety: ensure cards become visible even if IntersectionObserver doesn't fire (e.g., older browsers, rare timing)
    setTimeout(() => {
        document.querySelectorAll('.feature-card').forEach(card => {
            if (!card.classList.contains('animate')) {
                card.classList.add('animate');
            }
        });
    }, 1200);
    
    // Observe stat cards with custom animation
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateX(-20px)';
        card.style.transition = `opacity 0.6s ease ${index * 0.15}s, transform 0.6s ease ${index * 0.15}s`;
        
        const statObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateX(0)';
                    statObserver.unobserve(entry.target);
                }
            });
        }, observerOptions);
        
        statObserver.observe(card);
    });

    // Initialize parallax effects
    initParallax();
    
    // Initialize animated counters
    initCounters();
});

// ========== Animated Counters ==========
function initCounters() {
    const counters = document.querySelectorAll('.stat-number');
    
    const counterObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const target = entry.target;
                const text = target.textContent.trim();
                
                // Handle special case for "24/7" - animate first number only
                if (text.includes('/')) {
                    const parts = text.split('/');
                    const firstNum = parseFloat(parts[0]);
                    const remainder = '/' + parts.slice(1).join('/');
                    
                    const duration = 2000;
                    const steps = 60;
                    const increment = firstNum / steps;
                    let current = 0;
                    let step = 0;
                    
                    const timer = setInterval(() => {
                        current += increment;
                        step++;
                        
                        if (step >= steps) {
                            current = firstNum;
                            clearInterval(timer);
                        }
                        
                        target.textContent = Math.floor(current) + remainder;
                    }, duration / steps);
                    
                    counterObserver.unobserve(target);
                    return;
                }
                
                // Extract number and suffix (e.g., "100M+" -> 100, "M+")
                const match = text.match(/([\d.]+)([^\d]*)/);
                if (!match) {
                    counterObserver.unobserve(target);
                    return;
                }
                
                const finalValue = parseFloat(match[1]);
                const suffix = match[2];
                const duration = 2000; // 2 seconds
                const steps = 60;
                const increment = finalValue / steps;
                let current = 0;
                let step = 0;
                
                const timer = setInterval(() => {
                    current += increment;
                    step++;
                    
                    if (step >= steps) {
                        current = finalValue;
                        clearInterval(timer);
                    }
                    
                    // Format with 1 decimal for decimals, none for integers
                    const formatted = finalValue % 1 === 0 ? 
                        Math.floor(current) : 
                        current.toFixed(1);
                    
                    target.textContent = formatted + suffix;
                }, duration / steps);
                
                counterObserver.unobserve(target);
            }
        });
    }, { threshold: 0.5 });
    
    counters.forEach(counter => counterObserver.observe(counter));
}

// Parallax implementation
function initParallax() {
    const sections = Array.from(document.querySelectorAll('[data-parallax]'));
    if (!sections.length) return;

    // Add a background layer if missing
    sections.forEach(section => {
        if (!section.querySelector('.parallax-bg')) {
            const bg = document.createElement('div');
            bg.className = 'parallax-bg';
            section.appendChild(bg);
        }
    });

    // Intersection Observer for fade-in and edge effects
    const fadeObserverOptions = {
        threshold: [0, 0.1, 0.5, 0.9, 1],
        rootMargin: '-10% 0px -10% 0px'
    };

    const fadeObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            const section = entry.target;
            
            // Fade in when entering viewport
            if (entry.isIntersecting && entry.intersectionRatio > 0.1) {
                section.classList.add('visible');
            }
            
            // Apply edge fading based on scroll position
            if (entry.intersectionRatio < 0.9 && entry.intersectionRatio > 0.1) {
                section.classList.add('fade-edges');
            } else {
                section.classList.remove('fade-edges');
            }
        });
    }, fadeObserverOptions);

    sections.forEach(section => fadeObserver.observe(section));

    const state = { ticking: false, y: window.scrollY };

    const onScroll = () => {
        state.y = window.scrollY || window.pageYOffset;
        if (!state.ticking) {
            state.ticking = true;
            requestAnimationFrame(() => {
                sections.forEach(sec => applyParallax(sec, state.y));
                state.ticking = false;
            });
        }
    };

    // Initial paint
    sections.forEach(sec => applyParallax(sec, state.y));
    window.addEventListener('scroll', onScroll, { passive: true });
}

function applyParallax(section, scrollY) {
    const rect = section.getBoundingClientRect();
    const top = rect.top + scrollY;
    const height = rect.height || 1;
    const progress = (scrollY - top + window.innerHeight) / (height + window.innerHeight);
    const eased = Math.max(0, Math.min(1, progress));
    
    // Get custom speed or use default
    const speed = parseFloat(section.getAttribute('data-speed')) || 0.5;
    const translateY = (eased - 0.5) * 100 * speed; // More aggressive range

    const bg = section.querySelector('.parallax-bg');
    if (bg) {
        bg.style.transform = `translate3d(0, ${translateY.toFixed(2)}px, 0) scale(${1 + Math.abs(eased - 0.5) * 0.1})`;
    }
    
    // Apply parallax to child elements with data-speed
    const parallaxElements = section.querySelectorAll('[data-speed]');
    parallaxElements.forEach(el => {
        if (el === section) return; // Skip section itself
        const elSpeed = parseFloat(el.getAttribute('data-speed'));
        const elTranslate = (eased - 0.5) * 60 * elSpeed;
        el.style.transform = `translate3d(0, ${elTranslate.toFixed(2)}px, 0)`;
    });
}
